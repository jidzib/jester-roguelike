@tool
class_name DungeonGenerator extends Node

@export_tool_button("Generate Dungeon") var dungeon_gen_button = generate
@export_tool_button("Clear All") var clear_tiles_button = clear_cells

@export var num_cells : int = 150
@export var min_cell_size : int = 64
@export var max_cell_size : int = 256 
@export var max_aspect_ratio : float = 1.75

@export var cells_container : Node2D
@export var debug_draw : Node2D

var rooms : Array[Rect2] = []

@export var corridor_width_tiles : int = 2
@export var streamer : DungeonStreamer

func generate() -> void:
	rooms = []
	var cells : Dictionary[Rect2, bool] = generate_cells()
	separate_cells(cells)

	var all_cells_array : Array[Rect2] = cells.keys()
	rooms = get_rooms(cells)

	var edges : Array[Edge] = triangulate_rooms(rooms)
	var mst_edges : Array[Edge] = compute_mst(rooms, edges)
	var remaining_edges : Array[Edge] = get_remaining_edges(edges, mst_edges)
	var extra_edges : Array[Edge] = add_extra_edges(remaining_edges, 0.15)
	var discarded_edges : Array[Edge] = get_remaining_edges(remaining_edges, extra_edges)
	var final_edges : Array[Edge] = mst_edges + extra_edges

	build_astar_grid(all_cells_array, rooms)
	var corridors : Array[PackedVector2Array] = generate_corridors(final_edges, rooms)

	if debug_draw:
		debug_draw.set_debug_data(all_cells_array, rooms, mst_edges, discarded_edges, extra_edges, corridors)

	# --- new: convert to AreaData and hand off to the streamer ---
	var room_data : Array[AreaData] = build_room_data(rooms)
	var corridor_data : Array[AreaData] = build_corridor_data(corridors, room_data.size())
	link_connections(room_data, corridor_data, final_edges, rooms)

	var all_area_data : Array[AreaData] = room_data + corridor_data
	if streamer:
		streamer.setup(all_area_data)

class Edge:
	var a : int
	var b : int
	var weight : float

	func _init(p_a: int, p_b: int, p_weight: float) -> void:
		a = p_a
		b = p_b
		weight = p_weight
		
func generate_cells() -> Dictionary[Rect2, bool]:
	var rng : RandomNumberGenerator = RandomNumberGenerator.new()
	rng.randomize()
	var cells : Dictionary[Rect2, bool] = {}
	var pull_ratio : float = 0.1
	var spawn_radius : float = sqrt(num_cells) * max_cell_size * pull_ratio

	for i in range(num_cells):
		var w : int = gaussian_size(rng)
		var h : int = gaussian_size(rng)
		h = clampi(h, int(w / max_aspect_ratio), int(w * max_aspect_ratio))
		var new_cell : Rect2
		new_cell.size = Vector2(w, h)
		new_cell.position = random_point_in_circle(spawn_radius, rng)
		cells.set(new_cell, true)
	return cells

func gaussian_size(rng: RandomNumberGenerator) -> int:
	var mean : float = min_cell_size
	var deviation : float = (max_cell_size - min_cell_size) / 2.5
	var value : float = rng.randfn(mean, deviation)
	return clampi(int(round(value)), min_cell_size, max_cell_size)

func random_point_in_circle(radius: float, rng: RandomNumberGenerator) -> Vector2:
	var angle : float = rng.randf_range(0, TAU)
	var dist : float = radius * sqrt(rng.randf())
	return Vector2(cos(angle), sin(angle)) * dist

func separate_cells(cells: Dictionary[Rect2, bool], padding: float = Util.TILE_SIZE) -> void:
	var cells_keys : Array[Rect2] = cells.keys()
	var count : int = 0
	var max_iterations : int = 2000
	
	while any_overlapping_cells(cells_keys, padding):
		for i in range(cells_keys.size()):
			for j in range(i + 1, cells_keys.size()):
				var a : Rect2 = cells_keys[i].grow(padding * 0.5)
				var b : Rect2 = cells_keys[j].grow(padding * 0.5)
				if !a.intersects(b):
					continue

				var overlap_x : float = min(a.position.x + a.size.x, b.position.x + b.size.x) - max(a.position.x, b.position.x)
				var overlap_y : float = min(a.position.y + a.size.y, b.position.y + b.size.y) - max(a.position.y, b.position.y)

				var center_diff : Vector2 = a.get_center() - b.get_center()
				if center_diff == Vector2.ZERO:
					center_diff = Vector2(randf_range(-1, 1), randf_range(-1, 1))

				var push : Vector2
				if overlap_x < overlap_y:
					push = Vector2(sign(center_diff.x) if center_diff.x != 0 else 1, 0) * (overlap_x * 0.5 + 0.5)
				else:
					push = Vector2(0, sign(center_diff.y) if center_diff.y != 0 else 1) * (overlap_y * 0.5 + 0.5)

				cells_keys[i].position += push
				cells_keys[j].position -= push

		count += 1
		if count > max_iterations:
			break

	cells.clear()
	for rect in cells_keys:
		cells[rect] = true

func any_overlapping_cells(cells: Array[Rect2], padding: float = 1.0) -> bool:
	for i in range(cells.size()):
		for j in range(i + 1, cells.size()):
			if cells[i].grow(padding * 0.5).intersects(cells[j].grow(padding * 0.5)):
				return true
	return false

func triangulate_rooms(rooms: Array[Rect2]) -> Array[Edge]:
	var centers : PackedVector2Array = PackedVector2Array()
	for room in rooms:
		centers.append(room.get_center())

	var triangle_indices : PackedInt32Array = Geometry2D.triangulate_delaunay(centers)

	var edges : Array[Edge] = []
	var seen_edges : Dictionary = {}

	for i in range(0, triangle_indices.size(), 3):
		var tri : Array[int] = [triangle_indices[i], triangle_indices[i + 1], triangle_indices[i + 2]]
		for k in range(3):
			var a : int = tri[k]
			var b : int = tri[(k + 1) % 3]
			_add_edge(a, b, centers, edges, seen_edges)

	return edges

func _add_edge(i: int, j: int, points: PackedVector2Array, edges: Array[Edge], seen: Dictionary) -> void:
	var key : Vector2i = Vector2i(min(i, j), max(i, j))
	if seen.has(key):
		return
	seen[key] = true
	edges.append(Edge.new(i, j, points[i].distance_to(points[j])))

func get_rooms(cells: Dictionary[Rect2, bool], room_area_threshold: float = 150000.0) -> Array[Rect2]:
	var _rooms : Array[Rect2] = []
	for cell in cells:
		if cell.get_area() > room_area_threshold:
			_rooms.append(cell)
	return _rooms

func compute_mst(rooms: Array[Rect2], all_edges: Array[Edge]) -> Array[Edge]:
	if rooms.is_empty():
		return []

	var adjacency : Dictionary = {}
	for i in range(rooms.size()):
		adjacency[i] = [] as Array[Edge]   # <-- explicitly typed, not just []

	for edge in all_edges:
		adjacency[edge.a].append(edge)
		adjacency[edge.b].append(edge)

	var start : int = -1
	for i in range(rooms.size()):
		if !adjacency[i].is_empty():
			start = i
			break
	if start == -1:
		push_warning("No edges at all - cannot build MST")
		return []

	var mst_edges : Array[Edge] = []
	var visited : Dictionary = {}
	visited[start] = true
	var frontier : Array[Edge] = adjacency[start].duplicate()

	while visited.size() < rooms.size() and !frontier.is_empty():
		var best_idx : int = -1
		var best_weight : float = INF
		for i in range(frontier.size()):
			var e : Edge = frontier[i]
			var a_visited : bool = visited.has(e.a)
			var b_visited : bool = visited.has(e.b)
			if a_visited == b_visited:
				continue
			if e.weight < best_weight:
				best_weight = e.weight
				best_idx = i

		if best_idx == -1:
			break

		var chosen : Edge = frontier[best_idx]
		frontier.remove_at(best_idx)
		var new_node : int = chosen.a if !visited.has(chosen.a) else chosen.b
		visited[new_node] = true
		mst_edges.append(chosen)

		for e in adjacency[new_node]:
			frontier.append(e)

	if visited.size() < rooms.size():
		push_warning("MST did not reach all rooms - %d/%d connected." % [visited.size(), rooms.size()])

	return mst_edges
	
func get_remaining_edges(all_edges: Array[Edge], mst_edges: Array[Edge]) -> Array[Edge]:
	var mst_keys : Dictionary = {}
	for e in mst_edges:
		mst_keys[Vector2i(min(e.a, e.b), max(e.a, e.b))] = true

	var remaining : Array[Edge] = []
	for e in all_edges:
		var key : Vector2i = Vector2i(min(e.a, e.b), max(e.a, e.b))
		if !mst_keys.has(key):
			remaining.append(e)
	return remaining

func add_extra_edges(remaining_edges: Array[Edge], percent: float = 0.15) -> Array[Edge]:
	var shuffled : Array[Edge] = remaining_edges.duplicate()
	shuffled.shuffle()
	var count : int = int(ceil(shuffled.size() * percent))
	var extra : Array[Edge] = []
	for i in range(count):
		extra.append(shuffled[i])
	return extra
	

@export var grid_cell_size : int = 32 # resolution of the pathfinding grid - smaller = more precise corridors, slower

var astar_grid : AStarGrid2D
var grid_origin : Vector2i # top-left of the grid in world space, for coordinate conversion

func build_astar_grid(all_cells: Array[Rect2], rooms: Array[Rect2]) -> void:
	var min_pos : Vector2 = Vector2.INF
	var max_pos : Vector2 = -Vector2.INF
	for cell in all_cells:
		min_pos = min_pos.min(cell.position)
		max_pos = max_pos.max(cell.position + cell.size)

	min_pos -= Vector2(grid_cell_size * 4, grid_cell_size * 4)
	max_pos += Vector2(grid_cell_size * 4, grid_cell_size * 4)

	grid_origin = Vector2i((min_pos / grid_cell_size).floor())
	var grid_size : Vector2i = Vector2i(((max_pos - min_pos) / grid_cell_size).ceil())

	astar_grid = AStarGrid2D.new()
	astar_grid.region = Rect2i(grid_origin, grid_size) # <-- region starts AT grid_origin, not zero
	astar_grid.cell_size = Vector2(grid_cell_size, grid_cell_size)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar_grid.update()

	# iterate using ABSOLUTE grid coordinates now, matching the region
	for x in range(grid_origin.x, grid_origin.x + grid_size.x):
		for y in range(grid_origin.y, grid_origin.y + grid_size.y):
			var world_pos : Vector2 = Vector2(x, y) * grid_cell_size
			var point : Vector2i = Vector2i(x, y)
			var in_room : bool = false
			for room in rooms:
				if room.has_point(world_pos):
					in_room = true
					break
			astar_grid.set_point_weight_scale(point, 5.0 if in_room else 1.0)

func world_to_grid(pos: Vector2) -> Vector2i:
	return Vector2i((pos / grid_cell_size).floor())

func grid_to_world(pos: Vector2i) -> Vector2:
	return Vector2(pos) * grid_cell_size

func generate_corridors(final_edges: Array[Edge], rooms: Array[Rect2]) -> Array[PackedVector2Array]:
	var corridors : Array[PackedVector2Array] = []

	for edge in final_edges:
		var start_world : Vector2 = rooms[edge.a].get_center()
		var end_world : Vector2 = rooms[edge.b].get_center()

		var start_grid : Vector2i = world_to_grid(start_world)
		var end_grid : Vector2i = world_to_grid(end_world)

		var path : PackedVector2Array = astar_grid.get_point_path(start_grid, end_grid)
		if path.is_empty():
			push_warning("No path found between rooms %d and %d" % [edge.a, edge.b])
			continue

		corridors.append(path)

	return corridors


func build_room_data(rooms: Array[Rect2]) -> Array[AreaData]:
	var result : Array[AreaData] = []
	for i in range(rooms.size()):
		var d := AreaData.new()
		d.id = i
		d.bounds = rooms[i]
		d.area_type = AreaData.AREA_TYPES.ROOM
		d.tile_cells = rect_to_cells(rooms[i])
		result.append(d)
	return result

func build_corridor_data(corridors: Array[PackedVector2Array], start_id: int) -> Array[AreaData]:
	var result : Array[AreaData] = []
	for i in range(corridors.size()):
		var path : PackedVector2Array = corridors[i]
		var d := AreaData.new()
		d.id = start_id + i
		d.area_type = AreaData.AREA_TYPES.CORRIDOR
		d.tile_cells = path_to_cells(path, corridor_width_tiles)
		d.bounds = path_bounding_rect(path, corridor_width_tiles)
		result.append(d)
	return result

# converts a room Rect2 (world space) into local tile coords, relative to the rect's own top-left
func rect_to_cells(rect: Rect2) -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var width_tiles : int = int(rect.size.x / Util.TILE_SIZE)
	var height_tiles : int = int(rect.size.y / Util.TILE_SIZE)
	for x in range(width_tiles):
		for y in range(height_tiles):
			cells.append(Vector2i(x, y))
	return cells

# walks a world-space polyline and stamps a corridor of given width (in tiles) along it,
# returning cells in LOCAL space relative to the corridor's own bounding rect top-left
func path_to_cells(path: PackedVector2Array, width_tiles: int) -> Array[Vector2i]:
	var bounds : Rect2 = path_bounding_rect(path, width_tiles)
	var origin_tile : Vector2i = Vector2i((bounds.position / Util.TILE_SIZE).floor())

	var cell_set : Dictionary = {} # dedupe via dictionary keys
	var half_width : int = int(width_tiles / 2.0)

	for i in range(path.size() - 1):
		var a : Vector2 = path[i]
		var b : Vector2 = path[i + 1]
		var a_tile : Vector2i = Vector2i((a / Util.TILE_SIZE).floor())
		var b_tile : Vector2i = Vector2i((b / Util.TILE_SIZE).floor())

		# walk along whichever axis this segment moves on (segments are axis-aligned from AStarGrid2D)
		if a_tile.y == b_tile.y:
			var x_start : int = min(a_tile.x, b_tile.x)
			var x_end : int = max(a_tile.x, b_tile.x)
			for x in range(x_start, x_end + 1):
				for w in range(-half_width, half_width + 1):
					var cell : Vector2i = Vector2i(x, a_tile.y + w) - origin_tile
					cell_set[cell] = true
		else:
			var y_start : int = min(a_tile.y, b_tile.y)
			var y_end : int = max(a_tile.y, b_tile.y)
			for y in range(y_start, y_end + 1):
				for w in range(-half_width, half_width + 1):
					var cell : Vector2i = Vector2i(a_tile.x + w, y) - origin_tile
					cell_set[cell] = true

	var cells : Array[Vector2i] = []
	for key in cell_set.keys():
		cells.append(key)
	return cells

# world-space bounding rect around a path, padded by corridor width, used as AreaData.bounds
func path_bounding_rect(path: PackedVector2Array, width_tiles: int) -> Rect2:
	var min_pos : Vector2 = Vector2.INF
	var max_pos : Vector2 = -Vector2.INF
	for p in path:
		min_pos = min_pos.min(p)
		max_pos = max_pos.max(p)
	var pad : float = width_tiles * Util.TILE_SIZE * 0.5
	min_pos -= Vector2(pad, pad)
	max_pos += Vector2(pad, pad)
	return Rect2(min_pos, max_pos - min_pos)

# stores which AreaData ids connect to which, so the streamer can pre-load neighbors
func link_connections(room_data: Array[AreaData], corridor_data: Array[AreaData], final_edges: Array[Edge], rooms: Array[Rect2]) -> void:
	for i in range(final_edges.size()):
		var edge : Edge = final_edges[i]
		var room_a : AreaData = room_data[edge.a]
		var room_b : AreaData = room_data[edge.b]
		var corridor : AreaData = corridor_data[i]

		room_a.connections.append(corridor.id)
		room_b.connections.append(corridor.id)
		corridor.connections.append(room_a.id)
		corridor.connections.append(room_b.id)

func clear_cells() -> void:
	for cell in cells_container.get_children():
		cell.queue_free()
	if streamer:
		streamer.clear()
	if debug_draw:
		debug_draw.set_debug_data([], [], [], [], [], [])
