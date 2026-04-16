# Script to store the game data that will end into a savefile and are needed to run the game
# Kept separate from the SaveManager for compartimentalization

extends Node

const GAME_NAME: String = "Space Druid Licence Renewal"
const GAME_VERSION: String = "0.3"

# GAME CONFIG
const KEY_MUSIC_VOLUME: String = "music_volume"
const KEY_SFX_VOLUME: String = "sfx_volume"

var config: Dictionary = {
	KEY_MUSIC_VOLUME: 100,
	KEY_SFX_VOLUME: 100
}

# GAME DATA
# Variables to keep track of during gameplay
var active_save_slot: int = 1

var current_fruits: Array = []

# FRUIT DATA
const KEY_KIDNEY_GRAPES: String = "kidney grapes"
const KEY_ALL_SEEING_CHERRY: String = "all-seeing cherry"
const KEY_COSMIC_WATERMELON: String = "cosmic watermelon"

const FRUIT_KEYS: Array = [KEY_KIDNEY_GRAPES, KEY_ALL_SEEING_CHERRY, KEY_COSMIC_WATERMELON] # used for fruit generation?

enum FruitParams {MAIN_TEXTURE, CHOPPED_TEXTURE, POWDER_TEXTURE, SINGLE_TEXTURE, IS_ANIMATED, SPEED, PATH_COMPLEXITY}

const FRUIT_DATA: Dictionary = {
	KEY_KIDNEY_GRAPES: {
		FruitParams.MAIN_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.CHOPPED_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.POWDER_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.SINGLE_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.IS_ANIMATED: false,
		FruitParams.SPEED: 25,
		FruitParams.PATH_COMPLEXITY: 0
	},
	KEY_ALL_SEEING_CHERRY: {
		FruitParams.MAIN_TEXTURE: "uid://bphmskpwbpnsv",
		FruitParams.CHOPPED_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.POWDER_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.SINGLE_TEXTURE: "uid://b5jttb4gpdhq4",
		FruitParams.IS_ANIMATED: true,
		FruitParams.SPEED: 15,
		FruitParams.PATH_COMPLEXITY: 0
	},
	KEY_COSMIC_WATERMELON: {
		FruitParams.MAIN_TEXTURE: "uid://caeunebcv8sgj",
		FruitParams.CHOPPED_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.POWDER_TEXTURE: "uid://cm1nj60d1c5rv",
		FruitParams.SINGLE_TEXTURE: "uid://cnju17kj1mg17",
		FruitParams.IS_ANIMATED: true,
		FruitParams.SPEED: 15,
		FruitParams.PATH_COMPLEXITY: 3
	}
}

const KEY_REQUIREMENTS: String = "requirements"
const KEY_FRUIT_NAME: String = "fruit_name"
const KEY_QTY: String = "qty"

const LEVELS: Dictionary = {
	1: {
		KEY_REQUIREMENTS: {
			1: {
				KEY_FRUIT_NAME: KEY_KIDNEY_GRAPES,
				KEY_QTY: 5
			},
			2: {
				KEY_FRUIT_NAME: KEY_ALL_SEEING_CHERRY,
				KEY_QTY: 5
			},
			3: {
				KEY_FRUIT_NAME: KEY_COSMIC_WATERMELON,
				KEY_QTY: 1
			},
		}
	}
}

# CHOPPING MINIGAME
var total_fruits_amount: int = 0
var current_fruits_amount: int = 0:
	set(new_value):
		current_fruits_amount = new_value
		SignalBus.chopping_fruit_amt_changed.emit(new_value)

# STIRRING MINIGAME
var stirring_ongoing = true

var current_chopped_hits: int = 0:
	set(new_value):
		current_chopped_hits = new_value
		SignalBus.chopping_happened.emit(new_value)

# KEYS
# Strings to organize the data into a Dictionary and later into a JSON
const KEY_GAME_VERSION: String = "game version"
const KEY_IS_NEW_GAME: String = "is new game"
const KEY_PROTOCOL_NUMBER: String = "protocol number"
const KEY_CURRENT_LEVEL: String = "current level"
const KEY_GRABBING_TIME: String = "grabbing time"
const KEY_GRABBING_JUNK_AMT: String = "grabbing junk"

# DEFAULT GAME DATA
# What to load into a new save
const DEFAULT_GAME_DATA: Dictionary = {
	KEY_GAME_VERSION: GAME_VERSION,
	KEY_IS_NEW_GAME: true, #TODO: change to false upon completing level 1
	KEY_PROTOCOL_NUMBER: "AA-12345",
	KEY_CURRENT_LEVEL: 1,
	KEY_GRABBING_TIME: 0.0,
	KEY_GRABBING_JUNK_AMT: 0
}

# CURRENT GAME DATA
# Dictionary to load the current state of the game into, and to pass into SavesManager
# Also polling this every time I need to know something

var current: Dictionary = DEFAULT_GAME_DATA.duplicate_deep() # Defaults to base game data on load

func _ready() -> void:
	# Load and apply configuration
	SavesManager.load_config(config)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"),config[KEY_MUSIC_VOLUME]/100.00)
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"),config[KEY_SFX_VOLUME]/100.00)

	SavesManager.load_save(current, active_save_slot)
	
func initiate_load_game_data() -> void:
	SavesManager.load_save(current, active_save_slot)

func initiate_save_game_data() -> void:
	SavesManager.save_game(current, active_save_slot)
