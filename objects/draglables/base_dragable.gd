extends CharacterBody2D

@onready var ray = $push_direction

var diagonals = [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)]

var hit_sound = preload("res://sound/sfx/dragable.wav")

var latest_direction = Vector2(0,0)

var cancel_movement = false

func push(dir, by_dragable:Node2D=null):
	
	#if pushed by another dragable turns diagonals into straights
	if dir in diagonals and by_dragable != null:
		dir = (global_position - by_dragable.global_position).normalized()
	
	
	# takes dir and simplify diagonals
	# turning diagonals like Vector2(0.707, 0.707) into Vector2(1, 1)
	dir = Vector2(sign(dir.x), sign(dir.y))
	
	latest_direction = dir
	
	var steps := 0
	
	for i in range(14):
		
		ray.target_position = dir * 16
		ray.force_raycast_update()
		
		if ray.is_colliding():
			check_contact(dir)
			break
		
		if cancel_movement:
			break
		
		await move(dir)
		
		
		steps += 1
	
	if steps:
		MusicNode.play_sfx(hit_sound)

func move(dir, disable=null):
	
	$CPUParticles2D.direction = Vector2(dir * -1)
	$CPUParticles2D.restart()
	
	var tween = create_tween()
	# move the character 16 pixels in the chosen direction
	tween.tween_property(
		self,
		"global_position",
		global_position + dir * 16 ,
		0.1 
	)
	
	await tween.finished
	
	if disable:
		cancel_movement = false
		Globals.player_move_disable = false

func check_contact(dir):
	
	var body = ray.get_collider()
	
	if body:
		
		Globals.player_move_disable = false
		
		if body.has_method("push"):
			body.push(dir,self)
		
		elif body.has_method("explode"):
			body.explode()
		
		return "body"


func _on_player_cliped_check_body_entered(body: Node2D) -> void:
	cancel_movement = true
	self.move(latest_direction * -1, "able_movement")
