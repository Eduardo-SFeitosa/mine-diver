extends StaticBody2D

@onready var sprite = $sprite
@onready var colision = $colision

enum _activated {No, Yes}
@export var activated : _activated

enum direction {top, left, right, bottom}
@export var door_direction : direction = direction.top

@export var trigers = 1

var current_triggers = 0

func _on_finish_area_body_entered(_body: Node2D) -> void:
	Globals.next_level.emit()

func _ready() -> void:
	
	deactivate()
	
	current_triggers += 1
	
	if activated == _activated.Yes:
		current_triggers = 200
		activate()
	
	var sprite_spin
	
	match door_direction:
		direction.top:
			sprite_spin = 0
		direction.right:
			sprite_spin = 90
		direction.bottom:
			sprite_spin = 180
		direction.left:
			sprite_spin = 270
	
	rotation = deg_to_rad(sprite_spin)

func activate():
	
	current_triggers += 1
	
	if current_triggers >= trigers:
		sprite.play("default")
		colision.set_deferred("disabled", true)

func deactivate():
	current_triggers -= 1
	
	if current_triggers == trigers - 1:
		sprite.play_backwards("default")
		colision.set_deferred("disabled", false)
