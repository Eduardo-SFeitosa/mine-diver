extends NinePatchRect

var dialogs : Array = ["teste1",
						"teste2",
						"teste3"]


@onready var box_text = $content_container/box_text

@onready var profile_container = $content_container/profile

@onready var profile_image = $content_container/profile/image_container/profile_image

@onready var profile_label = $content_container/profile/label

@onready var content_container = $content_container

var characters = {
	"agent b" : {
		"texture" : "res://cutscenes/sprites/agent_b.png"
	},
	"contractor" : {
		"texture" : "res://cutscenes/sprites/miner.png"
	},
	"warning" : {
		"texture" : "res://cutscenes/sprites/warning.png"
	}
}

#profile info changed 
var profile_texture : Texture

var profile_name : String = ""

#invert text and image
@export var inverse_text : bool = false


#generating text vatiables
var letter_index = 0

var dialog_index = 0

@onready var letter_timer = $letter_display

signal dialog_ended

var paused = true

var destroy_after_end = false

func _ready() -> void:
	
	if inverse_text:
		
		content_container.move_child(profile_container, 1)
		
		$AnimationPlayer.play("arrow_reverse")
		
	
	profile_image.texture = load(characters[profile_name]["texture"])
	
	
	profile_label.text = profile_name
	
	
	var tween = create_tween()
	
	tween.tween_property(self, "scale", Vector2(1,1), 0.4).from(Vector2(1,0))
	
	await tween.finished
	
	paused = false
	
	letter_timer.start()


func _input(event: InputEvent) -> void:
	
	if Input.is_action_just_pressed("left_click") or Input.is_action_just_pressed("space"):
		
		$dialog_sound.stop()
		
		if paused: 
			return
		
		letter_timer.stop()
		
		if len(dialogs) -1  == dialog_index and not letter_index < len(dialogs[dialog_index]):
			
			paused = true
			
			$pause.stop()
			
			dialog_ended.emit()
			
			if destroy_after_end:
				queue_free()
			
			$finish_arrow.visible = false
		
		
		
		elif letter_index < len(dialogs[dialog_index]):
			box_text.text = dialogs[dialog_index]
			letter_index = len(dialogs[dialog_index])
			
			paused = true
			
			$pause.start()
			
			$finish_arrow.visible = true
		
		elif len(dialogs) > dialog_index:
			
			box_text.text = ""
			letter_index = 0
			dialog_index += 1
			letter_timer.start()
			
			$finish_arrow.visible = false
			
			if dialogs[dialog_index] == "BOOOM!":
				$explosion.play()


func _on_letter_display_timeout() -> void:
	
	if len(dialogs[dialog_index]) == letter_index:
		letter_timer.stop()
		$finish_arrow.visible = true
		$dialog_sound.stop()
		return
	
	if letter_index == 0:
		$dialog_sound.play()
	
	box_text.text += dialogs[dialog_index][letter_index]
	
	letter_index += 1


func _on_pause_timeout() -> void:
	paused = false
