extends Node2D
@onready var laps_label: Label = $CanvasLayer/TopBar/MarginContainer/LapsContainer/MarginContainer/HBoxContainer/LapsLabel
@onready var minigame_scene: Node2D = $MinigameScene
@onready var top_message_label: Label = $CanvasLayer/TopBar/TopMessageLabel

var can_start: bool = false
var laps: int = 0
var color_picked: Color 

func _ready() -> void:
	GameData.initiate_load_game_data()
	SignalBus.laps_updated.connect(update_laps)
	SignalBus.finished_rotating.connect(finish_minigame)
	minigame_scene.position.x = (get_viewport_rect().size.x/2)-(240/2)
	get_tree().root.size_changed.connect(on_viewport_size_changed)

	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		PopupManager.show_popup_dialog("The final step of the Space Potion brewing process is cooking the ground Space Fruit in the Rocket Powered Cauldron (RPC).")
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog("Rocket fuel is limited, fire the rocket only when the ladle can be hit by the flames!")
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog("The more complete spins you can make, the better the grade!", "Start")
		await PopupManager.next_button_pressed
	print("popup dismissed")
	can_start = true

func _input(event):
	if event.is_action_released("Interact") and can_start == true:
		# await get_tree().create_timer(1.0).timeout # hacky asf
		GameData.stirring_ongoing = true
		top_message_label.text = "HOLD CLICK TO FIRE"

func update_laps(value: int) -> void:
	laps_label.text = str(value)
	laps = value

func finish_minigame() -> void:
	GameData.current[GameData.KEY_REVOLUTIONS_DONE] = laps
	GameData.initiate_save_game_data()
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_GRADING_SCREEN])

#https://forum.godotengine.org/t/how-do-i-detect-when-the-window-is-resized/121381
func on_viewport_size_changed():
	minigame_scene.position.x = (get_viewport_rect().size.x/2)-(240/2)
