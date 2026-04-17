extends Node2D

@export var fruit_scene: PackedScene

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
@onready var animation_player: AnimationPlayer = $CanvasLayer/TextureRect/AnimationPlayer

var minigame_started: bool = false
var grabbing_enabled: bool = false

var elapsed_time: float = 0.0
var junk_collected: int = 0:
	set(new_value):
		junk_collected = new_value
		update_junk_label(new_value)

var ingredient_1_name: String 
var ingredient_1_target_qty: int = 0
var ingredient_1_current_qty: int = 0:
	set(new_value):
		ingredient_1_current_qty = new_value
		update_ingredient_1_label(new_value)

var ingredient_2_name: String
var ingredient_2_target_qty: int = 0
var ingredient_2_current_qty: int = 0:
	set(new_value):
		ingredient_2_current_qty = new_value
		update_ingredient_2_label(new_value)

var ingredient_3_name: String
var ingredient_3_target_qty: int = 0
var ingredient_3_current_qty: int = 0:
	set(new_value):
		ingredient_3_current_qty = new_value
		update_ingredient_3_label(new_value)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_path.position.x = (get_viewport_rect().size.x/2)-(240/2)
	SignalBus.fruit_grabbed.connect(parse_grabbed_fruit)
	SignalBus.spawn_fruit.connect(spawn_fruit)
	get_tree().root.size_changed.connect(on_viewport_size_changed)
	set_process(false)
	
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		PopupManager.show_popup_dialog("Space Fruit grows randomly in dedicated pocket dimensions. You have the GDG's permission to open portals to them.")
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog("Use your Teleportation Gun to zap the required Space Fruit as fast as you can. The faster, the better your final grade.")
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog("Try to zap only the required Space Fruit. Getting unnecessary ingredients will lower your final grade.", "Start")
		await PopupManager.next_button_pressed
	
	animation_player.play_backwards("fadein")
	await animation_player.animation_finished
	
	top_message_label.text = "HIT SPACE TO START"
	
	ingredient_1_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_FRUIT_NAME]
	var ingredient_1_icon_file = load(GameData.FRUIT_DATA[ingredient_1_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_1_texture.texture = ingredient_1_icon_file
	ingredient_1_target_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_QTY]
	# ingredient_1_qty_label.text = str(ingredient_1_qty, "x")
	# ingredient_1_name_label.text = ingredient_1_name.to_upper()
	
	ingredient_2_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_FRUIT_NAME]
	var ingredient_2_icon_file = load(GameData.FRUIT_DATA[ingredient_2_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_2_texture.texture = ingredient_2_icon_file
	ingredient_2_target_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_QTY]
	# ingredient_2_qty_label.text = str(ingredient_2_qty, "x")
	# ingredient_2_name_label.text = ingredient_2_name.to_upper()
	
	ingredient_3_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_FRUIT_NAME]
	var ingredient_3_icon_file = load(GameData.FRUIT_DATA[ingredient_3_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_3_texture.texture = ingredient_3_icon_file
	ingredient_3_target_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_QTY]
	#ingredient_3_qty_label.text = str(ingredient_3_qty, "x")
	#ingredient_3_name_label.text = ingredient_3_name.to_upper()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if grabbing_enabled == true:
		elapsed_time += delta
		top_message_label.text = str("ELAPSED TIME: %0.2f" % elapsed_time,"s")
		
		if (
			ingredient_1_current_qty >= ingredient_1_target_qty and
			ingredient_2_current_qty >= ingredient_2_target_qty and
			ingredient_3_current_qty >= ingredient_3_target_qty
		):
			end_grabbing_minigame()

func _input(event):
	if event.is_action_pressed("Interact") and !minigame_started and grabbing_enabled == false:
		minigame_started = true
		set_process(true)
		start_countdown()
	# elif check mouse position for fruit

func start_countdown() -> void:
	spawn_fruit(70)

	top_message_label.text = "START IN 3..."
	await get_tree().create_timer(1.0).timeout
	top_message_label.text = "START IN 2..."
	await get_tree().create_timer(1.0).timeout
	top_message_label.text = "START IN 1..."
	await get_tree().create_timer(1.0).timeout
	grabbing_enabled = true
	click_blocker.hide()

func spawn_fruit(amt: int = 1) -> void:
	for x in amt:
		var new_fruit := fruit_scene.instantiate()
		var picked_fruit = GameData.FRUIT_KEYS.pick_random() #TODO: weighted random
		
		#instead of calling a function here, set parameters as variables
		new_fruit.fruit_type = str(picked_fruit)
		print("Spawning ", picked_fruit)
		new_fruit.sprite_full_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.MAIN_TEXTURE]
		new_fruit.sprite_chopped_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.CHOPPED_TEXTURE]
		new_fruit.grabbing_sprite_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SINGLE_TEXTURE]
		new_fruit.is_animated = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.IS_ANIMATED]
		new_fruit.speed = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SPEED]
		new_fruit.path_complexity = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.PATH_COMPLEXITY]
		
		#TODO: use some offsetted rects or smth for spawn point, path doesn't scale well
		var start_point_ratio: float = randf()
		path_follow_2d.progress_ratio = start_point_ratio
		var start_point_pos: Vector2 = path_follow_2d.global_position
		
		new_fruit.position = start_point_pos
		
		var end_point_ratio: float = randf()
		path_follow_2d.progress_ratio = end_point_ratio
		var end_point_pos: Vector2 = path_follow_2d.global_position
		
		add_child(new_fruit)
		new_fruit.start_pathing(start_point_pos, end_point_pos)
	
func end_grabbing_minigame() -> void:
	click_blocker.show()
	grabbing_enabled = false
	
	GameData.current[GameData.KEY_GRABBING_TIME] = elapsed_time
	GameData.current[GameData.KEY_GRABBING_JUNK_AMT] = junk_collected
	print(GameData.current_fruits)
	SavesManager.save_game(GameData.current)
	
	animation_player.play("fadein")
	await animation_player.animation_finished
	
	PopupManager.show_popup_dialog(str(
		"Zapped all the ingredients!\n",
		ingredient_1_name.to_upper(), ": ", ingredient_1_current_qty, "/", ingredient_1_target_qty, "\n",
		ingredient_2_name.to_upper(), ": ", ingredient_2_current_qty, "/", ingredient_2_target_qty, "\n",
		ingredient_3_name.to_upper(), ": ", ingredient_3_current_qty, "/", ingredient_3_target_qty, "\n",
		"UNNECESSARY FRUIT: ", junk_collected, "\n",
		"TOTAL TIME: ", round_to_dec(elapsed_time,2), "s" #TODO: convert in minutes and seconds, same above
	), "Proceed")
	await PopupManager.next_button_pressed
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_CHOPPING_MINIGAME])
	
func parse_grabbed_fruit(type: String) -> void:
	print("Grabbed ", type)
	match type:
		ingredient_1_name:
			if(ingredient_1_current_qty == ingredient_1_target_qty):
				junk_collected += 1
			else: ingredient_1_current_qty += 1
		ingredient_2_name:
			if(ingredient_2_current_qty == ingredient_2_target_qty):
				junk_collected += 1
			else: ingredient_2_current_qty += 1
		ingredient_3_name:
			if(ingredient_3_current_qty == ingredient_3_target_qty):
				junk_collected += 1
			else: ingredient_3_current_qty += 1
		_:
			junk_collected += 1

func update_ingredient_1_label(value: int) -> void:
	ingredient_1_label.text = str(value, "/", ingredient_1_target_qty)
	
func update_ingredient_2_label(value: int) -> void:
	ingredient_2_label.text = str(value, "/", ingredient_2_target_qty)
	
func update_ingredient_3_label(value: int) -> void:
	ingredient_3_label.text = str(value, "/", ingredient_3_target_qty)
	
func update_junk_label(value: int) -> void:
	junk_label.text = str(value)

# https://forum.godotengine.org/t/how-to-round-to-a-specific-decimal-place/27552/2
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
#https://forum.godotengine.org/t/how-do-i-detect-when-the-window-is-resized/121381
func on_viewport_size_changed():
	spawn_path.position.x = (get_viewport_rect().size.x/2)-(240/2)
