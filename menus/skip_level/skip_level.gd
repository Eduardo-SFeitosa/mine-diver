extends Control

var current_button

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

signal skip_level

func _ready() -> void:
	
	$yes.connect("mouse_entered" ,hover_entered.bind($yes))
	$yes.connect("mouse_exited" ,hover_exited.bind($yes))
	
	$no.connect("mouse_entered" ,hover_entered.bind($no))
	$no.connect("mouse_exited" ,hover_exited.bind($no))

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
	
	
	match current_button:
		
		"no":
			queue_free()
		
		"yes":
			skip_level.emit()
			queue_free()
