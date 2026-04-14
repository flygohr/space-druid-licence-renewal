extends Node2D

func _on_continue_button_pressed() -> void:
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_ASSIGNMENT_SCREEN])
