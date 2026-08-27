@tool
extends Node2D

var all_cells : Array[Rect2] = []
var rooms : Array[Rect2] = []
var mst_edges : Array = []           # Array[Edge] - the spanning tree
var remaining_edges : Array = []     # Array[Edge] - discarded leftover Delaunay edges
var extra_edges : Array = []         # Array[Edge] - re-added loop edges
var corridors : Array[PackedVector2Array] = [] # actual A* paths between rooms

func set_debug_data(
	p_all_cells: Array[Rect2],
	p_rooms: Array[Rect2],
	p_mst_edges: Array,
	p_remaining_edges: Array = [],
	p_extra_edges: Array = [],
	p_corridors: Array[PackedVector2Array] = []
) -> void:
	all_cells = p_all_cells
	rooms = p_rooms
	mst_edges = p_mst_edges
	remaining_edges = p_remaining_edges
	extra_edges = p_extra_edges
	corridors = p_corridors
	queue_redraw()

func _draw() -> void:
	# non-room cells: faint gray outlines
	for cell in all_cells:
		draw_rect(cell, Color(0.5, 0.5, 0.5, 0.3), false, 1.0)

	# rooms: filled, colored
	for room in rooms:
		draw_rect(room, Color(0.2, 0.6, 1.0, 0.5), true)
		draw_rect(room, Color(0.2, 0.6, 1.0, 1.0), false, 2.0)

	# discarded leftover Delaunay edges - dim red
	for edge in remaining_edges:
		var point_a : Vector2 = rooms[edge.a].get_center()
		var point_b : Vector2 = rooms[edge.b].get_center()
		draw_line(point_a, point_b, Color(1.0, 0.3, 0.3, 0.25), 1.0)

	# MST edges - solid white (kept faint now that corridors show the real route)
	for edge in mst_edges:
		var point_a : Vector2 = rooms[edge.a].get_center()
		var point_b : Vector2 = rooms[edge.b].get_center()
		draw_line(point_a, point_b, Color(1.0, 1.0, 1.0, 0.3), 1.0)

	# re-added extra edges (loops) - dim yellow
	for edge in extra_edges:
		var point_a : Vector2 = rooms[edge.a].get_center()
		var point_b : Vector2 = rooms[edge.b].get_center()
		draw_line(point_a, point_b, Color(1.0, 0.9, 0.0, 0.3), 1.0)

	# actual corridor paths - bright green, drawn on top, this is the real routed geometry
	for path in corridors:
		for i in range(path.size() - 1):
			draw_line(path[i], path[i + 1], Color(0.2, 1.0, 0.3), 2.5)

	# room centers on top of everything
	for room in rooms:
		draw_circle(room.get_center(), 3.0, Color.RED)
