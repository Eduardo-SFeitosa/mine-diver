extends CanvasLayer

@onready var buttons_container = $buttons

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

var current_button

func _ready() -> void:
	
	get_tree().paused = true
	
	$explosion_sound.play()
	
	for button in buttons_container.get_children():
		
		button.connect("mouse_entered" ,hover_entered.bind(button))
		button.connect("mouse_exited" ,hover_exited.bind(button))
		
		

func hover_entered(button):
	
	current_button = button.name
	
	button.texture = button_hover

func hover_exited(button):
	
	current_button = null
	
	button.texture = button_normal

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("reset"):
		Transition.pixel_transition(Globals.current_level.get_path(), true)
	
	if Input.is_action_just_pressed("left_click") and current_button:
		button_pressed()

func button_pressed():
	
	get_tree().paused = false
	
	$button_pressed.play()
	
	match current_button:
		"restart":
			Transition.pixel_transition(Globals.current_level.get_path(), true)
		"menu":
			Transition.pixel_transition("res://menus/main_menu/main_menu.tscn")
