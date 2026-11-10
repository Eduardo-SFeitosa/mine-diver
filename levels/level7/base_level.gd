extends BaseLevel

func _on_timer_timeout() -> void:
	$base_explodable.explode(false)
