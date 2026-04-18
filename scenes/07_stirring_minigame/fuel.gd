extends ProgressBar

func _on_value_changed(value: float) -> void:
	if value <= 50 and value > 20:
		pass # color orange
	elif value <= 20:
		pass # color red
