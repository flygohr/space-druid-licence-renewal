extends Node2D

func _on_start_button_pressed() -> void:
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_GRABBING_MINIGAME])
