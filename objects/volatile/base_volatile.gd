extends StaticBody2D

func explode():
	
	Globals.current_level.explode(global_position, "volatile")
	
	call_deferred("queue_free")
	
