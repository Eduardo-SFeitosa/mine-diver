extends Control

class_name Base_Cutscene

@onready var dialog_scene = preload("res://menus/dialog_box/dialog_box.tscn")

@onready var dialogs_container = $dialog_boxes

@onready var button_hover = load("res://GUI/sprites/button_hover.png")
@onready var button_normal = load("res://GUI/sprites/button_normal.png")

enum chracther_name {agent_b, contractor}

@export var dialogs: Array[DialogLine]



@export var rail_paralax = true

func _process(delta: float) -> void:
	
	if rail_paralax:
		$ParallaxBackground/ParallaxLayer.motion_offset.x -= 30 * delta

var current_button

@export var go_to_level = 0

func _ready() -> void:
	
	$skip.connect("mouse_entered" ,hover_entered.bind($skip))
	$skip.connect("mouse_exited" ,hover_exited.bind($skip))
	
	MusicNode.play_music("stop")
	
	Save.save_content.cutscenes_seen += 1
	
	Save._save()

var current_dialog = 0

func create_dialog():
	
	
	if len(dialogs) <= current_dialog:
		
		$dissolve_animation.play("continue")
		
		await $dissolve_animation.animation_finished
		
		level_transition()
		
		return
	
	var new_dialog_scene = dialog_scene.instantiate()
	
	new_dialog_scene.dialogs = dialogs[current_dialog].text
	
	new_dialog_scene.profile_name = dialogs[current_dialog].name
	
	new_dialog_scene.connect("dialog_ended", create_dialog)
	
	
	
	new_dialog_scene.inverse_text = dialogs[current_dialog].invert_text
	
	dialogs_container.add_child(new_dialog_scene)
	
	current_dialog += 1

func level_transition():
	
	if go_to_level > 0:
			
			Transition.pixel_transition(LevelsDb.levels[go_to_level - 1]['path'])
			
			return
	
	Transition.pixel_transition("res://menus/final_credits/final_credits.tscn")

func hover_entered(button):
	
	current_button = button.name
	
	button.texture = button_hover


func hover_exited(button):
	
	current_button = null
	
	button.texture = button_normal


func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click") and current_button:
		level_transition()
