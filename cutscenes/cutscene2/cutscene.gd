extends Base_Cutscene


func create_dialog():
	
	current_dialog
	
	if current_dialog == 1:
		$broken_rail_animation.play("broken_rail")
		
		current_dialog += 1
		
		return
	
	if current_dialog == 3:
		
		$broken_rail_animation.play("broken_bomb")
		
		current_dialog += 1
		
		return
	
	
	if current_dialog == 5:
		
		level_transition()
		
		$dissolve_effect.color = Color(0,0,0,1)
	
	super.create_dialog()


func reset_dialogs():
	
	for dialog in $dialog_boxes.get_children():
			dialog.queue_free()
	
	$dialog_boxes.z_index = 10
