extends CanvasLayer

@onready var rect: ColorRect = $dissolve
@onready var mat: ShaderMaterial = rect.material as ShaderMaterial

@onready var transition_down = preload("res://menus/transition/transition_down.wav")

@onready var transition_up = preload("res://menus/transition/transition_up.wav")

func pixel_transition(new_scene: String, reload=false):
	rect.visible = true
	mat.set_shader_parameter("pixel_size", 32.0)
	
	
	MusicNode.play_sfx(transition_down, -10)
	
	var tween := create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("pixel_size", v),
		1.0,
		48.0,
		0.4
	)
	
	await tween.finished
	
	if reload:
		get_tree().reload_current_scene()
	
	else:
		get_tree().call_deferred("change_scene_to_file", new_scene)
	
	
	MusicNode.play_sfx(transition_up, -10)
	
	tween = create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("pixel_size", v),
		48.0,
		1.0,
		0.4
	)
	
	await tween.finished
	rect.visible = false
