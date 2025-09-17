extends ProgressBar

func _process(delta: float) -> void:
	if value != Global.health:
		value = Global.health
