extends CharacterBody2D

enum dir {left,right,up,down}

@onready var sprite = $sprite

@export var enemy_direction : dir

@onready var ray = $colision_ray

#if enemy_direction is right or down activate to make functions add or subtract enum correctly
var inverse_direction = false

var directions = {
	dir.left : Vector2(-1,0),
	dir.right : Vector2(1,0),
	dir.up : Vector2(0,-1),
	dir.down : Vector2(0,1)
}

func _ready() -> void:
	
	Globals.player_movement.connect(move)
	
	update_direction(directions[enemy_direction])
	
	if enemy_direction == dir.right or enemy_direction == dir.down:
		inverse_direction = true
	
	ray.target_position = directions[enemy_direction] * 16
	
	ray.force_raycast_update()

func move():
	
	var target_position = directions[enemy_direction]
	
	ray.target_position = directions[enemy_direction] * 16
	
	var object_colision = ray.get_collider()
	
	if object_colision:
		target_position = target_position * -1 
		
		enemy_direction += 1 if not inverse_direction else -1
		
		inverse_direction = !inverse_direction
		
		ray.target_position = directions[enemy_direction] * 16
		
		ray.force_raycast_update()
		
		object_colision = ray.get_collider()
		
		if object_colision:
			return
	
	update_direction(target_position)
	
	var tween := create_tween()
	tween.tween_property(self, "global_position", global_position + (target_position * 16), 0.15)
	

func update_direction(direction):
	
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			sprite.flip_h = false
			sprite.play("default")
		else:
			sprite.flip_h = true
			sprite.play("default")
	else:
		if (Globals.player_position - global_position).x > 0:
				sprite.flip_h = false
		else:
			sprite.flip_h = true
	sprite.frame = randi() % sprite.sprite_frames.get_frame_count(sprite.animation)

func explode():
	
	Globals.current_level.explode(global_position, "spider")
	
	sprite.play("death")
	
	call_deferred("queue_free")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "player":
		body.player_damage()
