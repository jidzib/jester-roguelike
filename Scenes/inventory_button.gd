extends TextureButton

@export var inventory : Inventory

func _ready() -> void:
	pressed.connect(toggle_inventory)

func toggle_inventory() -> void:
	inventory.visible = !inventory.visible
