extends Node2D

const TITLE_SCREEN_SCENE: StringName = ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_TITLE_SCREEN]
const GAME_SCREEN_SCENE: StringName = ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_GAME_SCREEN]

var scene_to_back_to: StringName = TITLE_SCREEN_SCENE

@onready var music_slider: HSlider = $CanvasLayer/MarginContainer/VBoxContainer/MusicSliderContainer/MusicSlider
@onready var music_slider_value: Label = $CanvasLayer/MarginContainer/VBoxContainer/MusicSliderContainer/MusicSliderValue
@onready var sfx_slider: HSlider = $CanvasLayer/MarginContainer/VBoxContainer/SFXSliderContainer/SFXSlider
@onready var sfx_slider_value: Label = $CanvasLayer/MarginContainer/VBoxContainer/SFXSliderContainer/SFXSliderValue
@onready var quit_button: Button = $CanvasLayer/MarginContainer/VBoxContainer/QuitButton

func _ready() -> void:	
	# Settings menu to look different depending on if in game or not
	
	SavesManager.load_config(GameData.config)
	music_slider.value = GameData.config[GameData.KEY_MUSIC_VOLUME]
	music_slider_value.text = str(GameData.config[GameData.KEY_MUSIC_VOLUME], "%")
	sfx_slider.value = GameData.config[GameData.KEY_SFX_VOLUME]
	sfx_slider_value.text = str(GameData.config[GameData.KEY_SFX_VOLUME], "%")
	
	if GameData.is_in_game == true:
		scene_to_back_to = GAME_SCREEN_SCENE
		quit_button.show()
	else: scene_to_back_to = TITLE_SCREEN_SCENE
	

func _on_back_button_pressed() -> void:
	ScenesManager.load_scene(scene_to_back_to)

func _on_export_save_button_pressed() -> void:
	SavesManager.export_save(GameData.current, GameData.GAME_NAME, GameData.GAME_VERSION, GameData.active_save_slot)

func _on_import_save_button_pressed() -> void:
	SavesManager.import_save(GameData.current, GameData.active_save_slot)

func _on_quit_button_pressed() -> void:
	ScenesManager.load_scene(TITLE_SCREEN_SCENE)

func _on_music_slider_value_changed(value: float) -> void:
	GameData.config[GameData.KEY_MUSIC_VOLUME] = int(value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),value/100)
	SavesManager.save_config(GameData.config)
	music_slider_value.text = (str(int(value),"%"))

func _on_sfx_slider_value_changed(value: float) -> void:
	GameData.config[GameData.KEY_SFX_VOLUME] = int(value)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),value/100)
	SavesManager.save_config(GameData.config)
	sfx_slider_value.text = (str(int(value),"%"))
