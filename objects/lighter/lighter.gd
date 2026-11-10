extends Area2D

func _on_body_entered(_body: Node2D) -> void:
	await get_tree().create_timer(0.1).timeout
	Globals.light_player_up.emit("big")
