@tool
extends HBoxContainer

@export var parent : Player

@export var texture : Texture2D
@export var max_hearts : int :
	set(value):
		max_hearts = value
		update_max_hearts(value)
		
var current_hearts : int

var HEARTS : Dictionary[int, Sprite2D] = {}

func _ready() -> void:
	current_hearts = max_hearts
	update_max_hearts(max_hearts)

func update_max_hearts(new_amount : int) -> void:
	for heart in get_children():
		heart.queue_free()
	HEARTS.clear()
	var full_heart_counter : int = 0
	for i in range(new_amount):
		var sprite : Sprite2D = Sprite2D.new()
		sprite.texture = texture
		sprite.vframes = 1
		sprite.hframes = 2
		if full_heart_counter != current_hearts:
			sprite.frame = 0
			full_heart_counter += 1
		else:
			sprite.frame = 1
		sprite.position.x = i * 20.0
		add_child(sprite)
		HEARTS.set(i, sprite)

func update(new_amount: int) -> void:
	if new_amount > current_hearts:
		gain_hearts(new_amount - current_hearts)
		#for i in range(new_amount - current_hearts):
			#if current_hearts >= max_hearts:
				#return
			#HEARTS[current_hearts].frame = 0
			#current_hearts += 1
	elif new_amount < current_hearts:
		lose_hearts(current_hearts - new_amount)
		#if new_amount < 0:
			#return
		#for i in range(current_hearts - new_amount):
			#HEARTS[current_hearts-1].frame = 1
			#current_hearts -= 1
			#if current_hearts <= 0:
				#return

func gain_hearts(amount : int) -> void:
	if amount < 0:
		return
	for i in range(amount):
		if current_hearts >= max_hearts:
			return
		HEARTS[current_hearts].frame = 0
		current_hearts += 1

func lose_hearts(amount : int) -> void:
	if amount < 0:
		return
	for i in range(amount):
		HEARTS[current_hearts-1].frame = 1
		current_hearts -= 1
		if current_hearts <= 0:
			return
		
func _on_tree_entered() -> void:
	#parent.lose_hp.connect(lose_hearts)
	#parent.gain_hp.connect(gain_hearts)
	
	parent.stats.update_hp.connect(update)
	
func _on_tree_exited() -> void:
	#parent.lose_hp.disconnect(lose_hearts)
	#parent.gain_hp.disconnect(gain_hearts)
	
	parent.stats.update_hp.disconnect(update)
