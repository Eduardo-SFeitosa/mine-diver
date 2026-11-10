extends StaticBody2D

@export var visibility = true

func _ready() -> void:
	if not visibility:
		$sprite.visible = false

func explode(delete=true):
	$sprite.visible = false
	$colision.disabled = true
	$CPUParticles2D.restart()
	await $CPUParticles2D.finished
	if delete:
		call_deferred("queue_free")
