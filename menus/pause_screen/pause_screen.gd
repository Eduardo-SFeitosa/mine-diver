extends Control

@onready var options_menu = preload("res://menus/options/options_in_game.tscn")
@onready var buttons_menu = preload("res://menus/controls/controls_in_game.tscn")


@onready var buttons_container = $buttons

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

var current_button

func _ready() -> void:
	
	get_tree().paused = true
	
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
	
	if Input.is_action_just_pressed("left_click") and current_button:
		button_pressed()

func button_pressed():
	
	$button_pressed.play()
	
	get_tree().paused = false
	
	match current_button:
		"continue":
			get_tree().paused = false
			queue_free()
		
		"buttons":
			var options = buttons_menu.instantiate()
			get_parent().add_child(options)
			queue_free()
		
		"options":
			var options = options_menu.instantiate()
			get_parent().add_child(options)
			queue_free()
		
		"menu":
			Transition.pixel_transition("res://menus/main_menu/main_menu.tscn")
			
