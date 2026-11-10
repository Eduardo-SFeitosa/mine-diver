extends Area2D

@onready var sprite = $sprite

enum type {doors, traps}
@export var button_type : type

signal activate

signal deactivate

func _ready() -> void:
	
	await get_tree().process_frame
	connect_objects()
	
	

func connect_objects():
	var objects
	
	if button_type == type.traps:
		objects = get_tree().get_nodes_in_group("traps")
	else:
		objects = get_tree().get_nodes_in_group("door")
	
	for object in objects:
		if button_type == type.traps:
			activate.connect(object.switch)
			deactivate.connect(object.switch)
		else:
			activate.connect(object.activate)
			deactivate.connect(object.deactivate)

func _on_body_entered(_body: Node2D) -> void:
	activate.emit()
	
	sprite.play("press")

func _on_body_exited(_body: Node2D) -> void:
	deactivate.emit()
	sprite.play_backwards("press")
