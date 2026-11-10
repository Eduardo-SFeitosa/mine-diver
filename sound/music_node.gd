extends AudioStreamPlayer

@onready var menu_music = load("res://sound/music/Curiosity (Black).mp3")

@onready var level_music = load("res://sound/music/Take it Back.mp3")

@onready var player := $"/root/MusicNode"

@onready var sfx = $sfx

@onready var music_keys = {
	"menu" : menu_music,
	"level" : level_music
}

var current_music = ""

func play_music(music: String, fade := true):
	
	if music == "stop":
		
		player.stop()
		
		current_music = music
		
		return
	
	if current_music == music:
		return  # already playing, do nothing
	
	current_music = music
	
	if fade and player.playing:
		await fade_out()
	
	player.stream = music_keys[music]
	player.play()
	
	if fade:
		fade_in()


func play_sfx(stream: AudioStream, reduce=0):
	
	if not is_inside_tree():
		return
	
	sfx.stream = stream
	
	sfx.volume_db = reduce
	
	sfx.play()


func stop_music(fade := true):
	if fade:
		await fade_out()
	player.stop()
	current_music = null


func fade_out(time := 0.5):
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, time)
	await tween.finished


func fade_in(time := 0.5):
	player.volume_db = -80
	var tween = create_tween()
	tween.tween_property(player, "volume_db", 0, time)
