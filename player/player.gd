extends CharacterBody2D

@onready var animations = $animations

var can_move = true

var in_moviment = false

var last_move : Vector2

signal moved

signal player_damaged

signal player_exploded

signal reset

signal hint

@onready var wall_hit = preload("res://player/sounds/wall_hit.wav")

func _ready() -> void:
	
	Globals.player_move_disable = false
	
	Globals.player_position = global_position



func _input(_event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("reset"):
		reset.emit()
	
	if Input.is_action_just_pressed("space") and not in_moviment and Globals.remaining_explosions > 0 and not Globals.lit_up:
		player_exploded.emit()
		return
	
	if Input.is_action_just_pressed("exit"):
		Globals.pause_game.emit()
	
	if Input.is_action_just_pressed("hint"):
		hint.emit()
	
	#check if player used movement keys and return them if used
	if not in_moviment and not Globals.player_move_disable:
		move(get_dir())


func move(dir):
	
	if dir == Vector2.ZERO:
		return
	
	if can_move and not in_moviment and not Globals.player_move_disable:
		
		#makes the player not move while already moving
		in_moviment = true
		
		if dir.x > 0 or dir.x < 0:
			animations.play("sides")
			animations.flip_h = true if dir.x < 0 else false
		else:
			var sprite_direction = "up" if dir.y < 0 else "down"
			animations.play(sprite_direction)
		
		if test_move(global_transform, dir * 16):
			
			MusicNode.play_sfx(wall_hit)
			$move_cooldown.start()
			return
		
		#animates the player moving from tile to tile
		var tween = create_tween()
		
		#move the character 16 pixels to the direction they chose within 0.2 seconds
		tween.tween_property(self, "global_position", global_position + dir * 16, 0.2)
		
		await tween.finished
		
		Globals.player_position = global_position
		
		last_move = dir
		
		#tells the level to make enemies and traps act
		Globals.player_movement.emit()
		
		#enables player movement again
		in_moviment = false


#check every move input and return if any was pressed
func get_dir() -> Vector2:
	
	var dir := Vector2.ZERO
	
	if Input.is_action_pressed("left"):
		dir.x -= 1
	if Input.is_action_pressed("right"):
		dir.x += 1
	if Input.is_action_pressed("up"):
		dir.y -= 1
	if Input.is_action_pressed("down"):
		dir.y += 1
	
	return dir

func player_damage():
	player_damaged.emit()

#activate death animation when player dies
func death():
	
	#disables player movement
	can_move = false
	
	#plays death animation
	animations.play("death")
	


func _on_move_cooldown_timeout() -> void:
	in_moviment = false
