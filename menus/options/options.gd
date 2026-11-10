extends Control

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

@onready var windowed_button = $options_control/control_container/screen_size/VBoxContainer/windowed
@onready var full_screen_button = $options_control/control_container/screen_size/VBoxContainer/full_screen

var current_button

@export var on_game = true

func _ready() -> void:
	
	$exit.connect("mouse_entered" ,hover_entered.bind($exit))
	$exit.connect("mouse_exited" ,hover_exited.bind($exit))
	
	if on_game:
		get_tree().paused = true
		
	
	var music_bus = AudioServer.get_bus_index("music")
	var sfx_bus = AudioServer.get_bus_index("sfx")
	
	var music_db = AudioServer.get_bus_volume_db(music_bus)
	var sfx_db = AudioServer.get_bus_volume_db(sfx_bus)
	
	$options_control/control_container/music_control/music_slider.value = db_to_linear(music_db)
	$options_control/control_container/sfx_control/sfx_slider.value = db_to_linear(sfx_db)

func hover_entered(button):
	
	current_button = button.name
	
	button.texture = button_hover


func hover_exited(button):
	
	current_button = null
	
	button.texture = button_normal


func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click") and current_button:
		
		$button_pressed.play()
		
		match current_button:
			
			"exit":
				
				if on_game:
					
					get_tree().paused = false
					
					queue_free()
					
				else:
					Transition.pixel_transition("res://menus/main_menu/main_menu.tscn")


func _on_music_slider_value_changed(value: float) -> void:
	
	var bus_index = AudioServer.get_bus_index("music")
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_sfx_slider_value_changed(value: float) -> void:
	
	var bus_index = AudioServer.get_bus_index("sfx")
	
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _on_windowed_pressed() -> void:
	
	full_screen_button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
	
	windowed_button.button_mask = 0
	
	toggle_fullscreen(false)
	
	windowed_button.button_pressed = true
	
	full_screen_button.button_pressed = false


func _on_full_screen_pressed() -> void:
	
	windowed_button.button_mask = MOUSE_BUTTON_MASK_LEFT | MOUSE_BUTTON_MASK_RIGHT
	
	full_screen_button.button_mask = 0
	
	full_screen_button.button_pressed = true
	
	windowed_button.button_pressed = false
	
	toggle_fullscreen(true)


func toggle_fullscreen(enable: bool):
	if enable:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_size(Vector2i(240 * 4, 160 * 4))
