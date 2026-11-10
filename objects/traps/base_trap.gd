extends Area2D

@export var active = false

@onready var sprite = $sprite

func _ready() -> void:
	
	if not active:
		deactivate()
	else:
		activate()


func switch():
	active = !active
	if active:
		deactivate()
	else:
		activate()

func deactivate():
	active = true
	
	sprite.play("activate")

func activate():
	active = false
	sprite.play_backwards("activate")

func _on_body_entered(body: Node2D) -> void:
	if active and body.has_method("player_damage"):
		body.player_damage()
