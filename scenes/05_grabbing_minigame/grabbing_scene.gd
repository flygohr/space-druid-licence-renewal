extends Node2D

@export var fruit_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_to_grab: Timer = $TimeToGrab

@onready var top_message_label: Label = $CanvasLayer/TopBar/TopMessageLabel

@onready var click_blocker: ColorRect = $CanvasLayer/ClickBlocker
@onready var spawn_path: Path2D = $SpawnPath
@onready var path_follow_2d: PathFollow2D = $SpawnPath/PathFollow2D

@onready var ingredient_1_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient1/MarginContainer/HBoxContainer/Ingredient1Texture
@onready var ingredient_1_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient1/MarginContainer/HBoxContainer/Ingredient1Label

@onready var ingredient_2_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient2/MarginContainer/HBoxContainer/Ingredient2Texture
@onready var ingredient_2_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient2/MarginContainer/HBoxContainer/Ingredient2Label

@onready var ingredient_3_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient3/MarginContainer/HBoxContainer/Ingredient3Texture
@onready var ingredient_3_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient3/MarginContainer/HBoxContainer/Ingredient3Label

@onready var junk_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Junk/MarginContainer/HBoxContainer/JunkLabel

var minigame_started: bool = false
var grabbing_enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	top_message_label.text = "HIT SPACE WHEN READY"
	
	var ingredient_1_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_FRUIT_NAME]
	var ingredient_1_icon_file = load(GameData.FRUIT_DATA[ingredient_1_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_1_texture.texture = ingredient_1_icon_file
	var ingredient_1_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_QTY]
	# ingredient_1_qty_label.text = str(ingredient_1_qty, "x")
	# ingredient_1_name_label.text = ingredient_1_name.to_upper()
	
	var ingredient_2_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_FRUIT_NAME]
	var ingredient_2_icon_file = load(GameData.FRUIT_DATA[ingredient_2_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_2_texture.texture = ingredient_2_icon_file
	var ingredient_2_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_QTY]
	# ingredient_2_qty_label.text = str(ingredient_2_qty, "x")
	# ingredient_2_name_label.text = ingredient_2_name.to_upper()
	
	var ingredient_3_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_FRUIT_NAME]
	var ingredient_3_icon_file = load(GameData.FRUIT_DATA[ingredient_3_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_3_texture.texture = ingredient_3_icon_file
	var ingredient_3_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_QTY]
	#ingredient_3_qty_label.text = str(ingredient_3_qty, "x")
	#ingredient_3_name_label.text = ingredient_3_name.to_upper()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbing_enabled == true:
		top_message_label.text = str("TIME LEFT: %0.2f" % time_to_grab.time_left,"s")

func _input(event):
	if event.is_action_pressed("Interact") and !minigame_started and grabbing_enabled == false:
		minigame_started = true
		set_process(true)
		start_countdown()
	# elif check mouse position for fruit

func start_countdown() -> void:
	spawn_timer.start()
	top_message_label.text = "START IN 3..."
	await get_tree().create_timer(1.0).timeout
	top_message_label.text = "START IN 2..."
	await get_tree().create_timer(1.0).timeout
	top_message_label.text = "START IN 1..."
	await get_tree().create_timer(1.0).timeout
	grabbing_enabled = true
	click_blocker.hide()
	time_to_grab.start()

func spawn_fruit() -> void:
	var new_fruit := fruit_scene.instantiate()
	var picked_fruit = GameData.FRUIT_KEYS.pick_random()
	
	#instead of calling a function here, set parameters as variables
	new_fruit.sprite_full_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.MAIN_TEXTURE]
	new_fruit.sprite_chopped_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.CHOPPED_TEXTURE]
	new_fruit.sprite_powder_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.POWDER_TEXTURE]
	new_fruit.grabbing_sprite_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SINGLE_TEXTURE]
	new_fruit.is_animated = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.IS_ANIMATED]
	new_fruit.speed = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SPEED]
	new_fruit.path_complexity = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.PATH_COMPLEXITY]
	
	var start_point_ratio: float = randf()
	path_follow_2d.progress_ratio = start_point_ratio
	var start_point_pos: Vector2 = path_follow_2d.global_position
	
	new_fruit.position = start_point_pos
	
	var end_point_ratio: float = randf()
	path_follow_2d.progress_ratio = end_point_ratio
	var end_point_pos: Vector2 = path_follow_2d.global_position
	
	add_child(new_fruit)
	new_fruit.start_pathing(start_point_pos, end_point_pos)

func _on_spawn_timer_timeout() -> void:
	spawn_fruit()
	
func _on_time_to_grab_timeout() -> void:
	spawn_timer.stop()
	click_blocker.show()
	print(GameData.current_fruits)
	await get_tree().create_timer(3.0).timeout
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_CHOPPING_MINIGAME])
