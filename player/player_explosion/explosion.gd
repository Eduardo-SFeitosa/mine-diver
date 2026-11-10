extends Area2D

var type = "player"

var direction : Vector2 = Vector2(0,0)

func _ready() -> void:
	$sprite.play(type)
	
	if type == "player":
		set_collision_mask_value(1, false)

#destroys itself after a short time
func _on_auto_destroy_timeout() -> void:
	
	var body = get_overlapping_bodies()
	
	if body:
		
		if body[0].has_method("explode"):
			body[0].explode()
		
		elif body[0].has_method("push"):
			Globals.player_move_disable = true
			body[0].push(direction)
		
		elif body[0].has_method("player_damage"):
			body[0].player_damage()
	call_deferred("queue_free")
	
	
