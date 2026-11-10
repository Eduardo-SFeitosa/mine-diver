extends Node2D

class_name BaseLevel

@onready var game_over_menu = preload("res://menus/game_over/game_over_screen.tscn")
@onready var explosion_scene = preload("res://player/player_explosion/explosion.tscn")
@onready var lightsource = preload("res://objects/lighter/lighter.tscn")
@onready var pause_menu = preload("res://menus/pause_screen/pause_screen.tscn")
@onready var dialog_box = preload("res://menus/dialog_box/dialog_box.tscn")
@onready var skip_level_scene = preload("res://menus/skip_level/skip_level.tscn")

@onready var player = $player
@onready var counter_label = $GUI/remaining_explosions/counter
@onready var countdown_label = $GUI/countdown/counter
@onready var countdown_clock = $GUI/countdown/clock

@onready var light_tile_set = $tilemaps/objects

@onready var explosion_sound = preload("res://sound/sfx/explosion.wav")
@onready var step_sound = preload("res://sound/sfx/player_move.wav")
@onready var liting_sound = preload("res://sound/sfx/liting.mp3")

#explosions and countdown explosions

@export var level_number : int = 1

#if the player controls or not when will explode
@export var _lit_up : bool = false
var lit_up : bool:
	set(value):
		Globals.lit_up = value
		countdown_label.visible = Globals.lit_up
	get:
		return Globals.lit_up
#how much time the countdown have until explode
@export var max_countdown : int = 3
#keep track of countdown until explosion
var explosion_countdown : int
#maximum amount of explosions the player can use
@export var _remaining_explosions : int = 3
#refreshes GUI and global variables
var remaining_explosions : int :
	set(value):
		Globals.remaining_explosions = value
		refresh_explosion_GUI()
	get:
		return Globals.remaining_explosions


@export var hint_dialog : Array[String] = []

var hint_given = false

enum bombActivation {countdown, input, both}
@export var bomb_activation : bombActivation 

@export var go_to_cutscene : int = 0

func _ready() -> void:
	
	hint_dialog.append("We can help you get through this hard spot")
	
	MusicNode.play_music("level")
	
	Globals.current_level = self
	
	Globals.next_level.connect(next_level)
	
	Globals.light_player_up.connect(lit_player_countdown)
	
	#connects player movement with the level
	Globals.player_movement.connect(player_acted)
	
	Globals.pause_game.connect(pause)
	
	player.connect("reset", reset_level)
	
	player.connect("player_damaged", player_damaged)
	
	player.connect("player_exploded", explode)
	
	player.connect("hint", show_hint)
	
	#refresh GUI and global variables
	remaining_explosions = _remaining_explosions
	lit_up = _lit_up
	
	#set countdown text
	counter_label.text = str(remaining_explosions)
	
	explosion_countdown = max_countdown
	
	countdown_label.text = str(max_countdown)
	
	countdown_clock.max_value = max_countdown
	
	if bomb_activation == bombActivation.countdown:
		$GUI/countdown.visible = true
		
		if not lit_up:
			countdown_clock.value = max_countdown
		
	elif bomb_activation == bombActivation.input:
		$GUI/remaining_explosions.visible = true
	
	else:
		$GUI/remaining_explosions.visible = true
		$GUI/countdown.visible = true
		
		if not lit_up:
			countdown_clock.value = max_countdown
		

func pause():
	
	if get_tree().paused == false:
		
		get_tree().paused = true
		
		var pause = pause_menu.instantiate()
		
		$GUI.add_child(pause)

func next_level(skip=false):
	
	await get_tree().create_timer(0.3).timeout
	
	var door = get_tree().get_nodes_in_group("door")[0]
	
	
	if door.current_triggers >= door.trigers or skip:
		
		Globals.player_move_disable = true
		
		if Save.save_content["levels_beaten"] == level_number:
			
			Save.save_content["levels_beaten"] += 1
			
			Save._save()
		
		if go_to_cutscene:
			
			Transition.pixel_transition(CutsceneDb.cutscenes[go_to_cutscene - 1].path)
			
			return
		
		Transition.pixel_transition(LevelsDb.levels[level_number].path)
	
	player.global_position += player.last_move * -1 * 16
	

func show_hint():
	
	var delete_last = hint_dialog if hint_given else hint_dialog.slice(0, hint_dialog.size() - 1)
	
	create_dialog(delete_last , hint_given)
	
	hint_given = true

func create_dialog(dialogs_list, connect=false):
	
	var new_dialog_box = dialog_box.instantiate()
	
	new_dialog_box.profile_name = "contractor"
	
	new_dialog_box.dialogs = dialogs_list
	
	new_dialog_box.destroy_after_end = true
	
	new_dialog_box.inverse_text = true
	
	if connect:
		new_dialog_box.connect("dialog_ended", skip_warning)
	
	$GUI.add_child(new_dialog_box)

func skip_warning():
	
	var new_warning = skip_level_scene.instantiate()
	
	new_warning.connect("skip_level", next_level.bind(true))
	
	$GUI.add_child(new_warning)

#reduce countdown, activate level hazards and enemies when player move
func player_acted():
	
	MusicNode.play_sfx(step_sound)
	
	if lit_up:
		
		if explosion_countdown == 1:
			
			explode(Vector2(0,0),"player",true)
			
			explosion_countdown = max_countdown
			
			countdown_clock.value = max_countdown
			
			countdown_label.text = str(max_countdown)
			
			lit_up = false
			
			player.modulate = Color(1,1,1)
		else:
			reduce_countdown()


func player_damaged():
	
	await get_tree().create_timer(0.2).timeout
	
	var game_over_screen = game_over_menu.instantiate()
	
	add_child(game_over_screen)


func lit_player_countdown(size):
	if size == "small":
		max_countdown = 4
	else:
		max_countdown = 7
	explosion_countdown = max_countdown 
	countdown_label.text = str(explosion_countdown)
	countdown_clock.max_value = max_countdown
	countdown_clock.value = 0
	lit_up = true
	player.modulate = Color(1,1,1)


func reduce_countdown():
	
	MusicNode.play_sfx(liting_sound)
	
	explosion_countdown -= 1
	
	countdown_label.text = str(explosion_countdown)
	
	countdown_clock.value += 1
	
	var ratio = (max_countdown - countdown_clock.value) / max_countdown 
	
	player.modulate = Color(1, ratio, ratio)


func refresh_explosion_GUI():
	
	counter_label.text = str(remaining_explosions)
	
	if explosion_countdown == 0:
		explosion_countdown = max_countdown


#directions the explosion scene will use in it's creation
var bomb_types = {
	"diagonals" : [Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)],
	"cross" : [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1)],
	"full" : [Vector2(1,0), Vector2(0,1), Vector2(-1,0), Vector2(0,-1),
	Vector2(-1,-1), Vector2(-1,1), Vector2(1,-1), Vector2(1,1)]
}

func explode(local=Vector2(0,0), type="player", lit_explosion=false):
	
	
	if type == "player":
		
		if not lit_explosion:
			remaining_explosions -= 1
		
		local = Globals.player_position
	
	MusicNode.play_sfx(explosion_sound)
	
	for direction in bomb_types["full"]:
		
		for i in range(1 ,2):
			
			var tile_explosion = explosion_scene.instantiate()
			
			
			tile_explosion.type = type
			
			#place explosion in tile based on the bomb type
			tile_explosion.global_position = local + direction * (16 * i)
			
			tile_explosion.direction = direction
			
			#add explosion to level
			get_parent().add_child(tile_explosion)


func player_input_explosion():
	
	if bomb_activation == bombActivation.input or bombActivation.both == bomb_activation:
		explode()

func reset_level():
	Transition.pixel_transition(self.get_path(), true)
