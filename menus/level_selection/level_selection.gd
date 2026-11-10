extends Control

@onready var door = preload("res://menus/level_selection/door.tscn")

@onready var buttons_container = $buttons

var current_button

func _ready() -> void:
	
	var button_count = 1
	
	for button in buttons_container.get_children():
		
		if Save.save_content["levels_beaten"] >= button_count:
			
			button.connect("mouse_entered", entered.bind(button))
			button.connect("mouse_exited", exited.bind(button))
			button_count += 1
		
		else:
			
			button.visible = false
			
			var new_door = door.instantiate()
			
			new_door.global_position = button.global_position
			
			call_deferred("add_child", new_door)
	
	
	$exit.connect("mouse_entered", entered.bind($exit))
	$exit.connect("mouse_exited", exited.bind($exit))

func entered(level):
	
	current_button = level.name.replace("button","")
	
	var style = level.get_theme_stylebox("panel").duplicate()
	
	style.border_width_left = 2
	style.border_width_right = 2
	style.border_width_top = 2
	style.border_width_bottom = 2
	
	level.add_theme_stylebox_override("panel", style)

func exited(level):
	
	current_button = null
	
	var style = level.get_theme_stylebox("panel").duplicate()
	
	style.border_width_left = 0
	style.border_width_right = 0
	style.border_width_top = 0
	style.border_width_bottom = 0
	
	level.add_theme_stylebox_override("panel", style)

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click") and current_button:
		
		$button_pressed.play()
		
		if current_button == "exit":
			Transition.pixel_transition("res://menus/main_menu/main_menu.tscn")
			return
		
		if Save.save_content.cutscenes_seen == 0:
			Transition.pixel_transition("res://cutscenes/cutscene1/cutscene.tscn")
			
			return
			
		
		Transition.pixel_transition(LevelsDb.levels[int(current_button) - 1]['path'])
	
