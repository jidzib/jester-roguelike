class_name DamageIndicator extends Node2D

@export var label : RichTextLabel
@export var lifetime : float = 1.0
@export var float_speed : float = 10
@export var decay_rate : float = 0.33
var time_alive : float = 0.0
var color : String

func initialize(damage: float, attack_type : CombatManager.COMBAT_STATS, _position: Vector2) -> void:
	process_color(attack_type)
	set_text(damage, color)
	global_position = _position	


func _physics_process(delta: float) -> void:
	position.y -= delta * float_speed
	
func _process(delta: float) -> void:
	time_alive += delta
	modulate.a -= delta * decay_rate
	if modulate.a <= 0 or time_alive > lifetime:
		queue_free()

func set_text(_damage: float, _color: String) -> void:
	label.text = "[color=%s]" % color + str(int(_damage)) + "[/color]" 
func process_color(attack_type: CombatManager.COMBAT_STATS) -> void:
	if attack_type == CombatManager.COMBAT_STATS.ATTACK:
		color = "red"
	elif attack_type == CombatManager.COMBAT_STATS.MAGIC_ATTACK:
		color = "blue"
