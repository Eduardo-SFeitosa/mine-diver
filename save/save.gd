extends Node


const save_path = "user://bomb_jam_save"


var save_content : Dictionary = {
	"levels_beaten" : 1,
	"cutscenes_seen" : 0
}

func reset_save():
	
	save_content = {
	"levels_beaten" : 1,
	"cutscenes_seen" : 0
	}
	
	_save()

func _ready() -> void:
	_load()

func _save():
	
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	
	file.store_var(save_content)
	
	file.close()

func _load():
	
	if FileAccess.file_exists(save_path):
		
		var file = FileAccess.open(save_path, FileAccess.READ)
		
		var data = file.get_var()
		
		file.close()
		
		save_content["levels_beaten"] = data["levels_beaten"]
		save_content["cutscenes_seen"] = data["cutscenes_seen"]
