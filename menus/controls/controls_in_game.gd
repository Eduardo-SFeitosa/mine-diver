extends Control

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

@onready var controls_menu = preload("res://menus/options/options_in_game.tscn")

var current_button

func _ready() -> void:
	
	$exit.connect("mouse_entered" ,hover_entered.bind($exit))
	$exit.connect("mouse_exited" ,hover_exited.bind($exit))
	
	get_tree().paused = true

func hover_entered(button):
	
	current_button = button.name
	
	button.texture = button_hover

func hover_exited(button):
	
	current_button = null
	
	button.texture = button_normal

func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click") and current_button:
		
		$button_pressed.play()
		
		get_tree().paused = false
		
		queue_free()
