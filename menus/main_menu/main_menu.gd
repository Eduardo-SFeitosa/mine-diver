extends Control

@onready var buttons_container = $buttons

@onready var player_animation = $player

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

@onready var reset_save = preload("res://menus/main_menu/warning/reset_warning.tscn")

var current_button

func _ready() -> void:
	
	

	$reset.visible = true
	
	for button in buttons_container.get_children():
		
		button.connect("mouse_entered" ,hover_entered.bind(button))
		button.connect("mouse_exited" ,hover_exited.bind(button))
	
	$credits.connect("mouse_entered" ,hover_entered.bind($credits))
	$credits.connect("mouse_exited" ,hover_exited.bind($credits))
	
	$reset.connect("mouse_entered" ,hover_entered.bind($reset))
	$reset.connect("mouse_exited" ,hover_exited.bind($reset))
	
	MusicNode.play_music("menu")

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
	
	match current_button:
		
		"play":
			
			Transition.pixel_transition("res://menus/level_selection/level_selection.tscn")
		
		"options":
			Transition.pixel_transition("res://menus/options/options_off_game.tscn")
		
		"exit":
			get_tree().quit()
		
		"credits":
			Transition.pixel_transition("res://menus/credits/credits.tscn")
		
		"reset":
			
			var reset = reset_save.instantiate()
			
			add_child(reset)
			

func _on_animation_timer_timeout() -> void:
	
	var tween = create_tween()
	
	tween.tween_property(player_animation
	,"global_position"
	, Vector2(248, player_animation.global_position.y)
	,8).from(Vector2(-8, player_animation.global_position.y))
	
	await tween.finished
	
	$animation_timer.start()
