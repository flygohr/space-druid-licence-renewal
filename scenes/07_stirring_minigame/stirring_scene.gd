extends Node2D
@onready var laps_label: Label = $CanvasLayer/TopBar/MarginContainer/LapsContainer/MarginContainer/HBoxContainer/LapsLabel
@onready var minigame_scene: Node2D = $MinigameScene

func _ready() -> void:
	SignalBus.laps_updated.connect(update_laps)
	minigame_scene.position.x = (get_viewport_rect().size.x/2)-(240/2)

func _input(event):
	if event.is_action_pressed("Interact"):
		GameData.stirring_ongoing = true

func update_laps(value: int) -> void:
	laps_label.text = str(value)

#https://forum.godotengine.org/t/how-do-i-detect-when-the-window-is-resized/121381
func on_viewport_size_changed():
	minigame_scene.position.x = (get_viewport_rect().size.x/2)-(240/2)
