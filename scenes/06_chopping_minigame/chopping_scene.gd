extends Node2D

# when ready, start the minigame
# start top slider
# when top slider is set, get its position and start second slider
# when both coords are set, draw cut line
# then calculate score to later add to globals

@onready var minigame_area: Node2D = $MinigameArea
@onready var top_slider: Node2D = $MinigameArea/TopSlider
@onready var bottom_slider: Node2D = $MinigameArea/BottomSlider
@onready var laser: Node2D = $MinigameArea/Laser
@onready var cutting_board: Node2D = $"MinigameArea/Cutting board"

@onready var top_message_label: Label = $CanvasLayer/TopBar/TopMessageLabel

@onready var shots_fired_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/ShotsFired/MarginContainer/HBoxContainer/ShotsFiredLabel

@onready var ingredient_1_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient1/MarginContainer/HBoxContainer/Ingredient1Texture
@onready var ingredient_1_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient1/MarginContainer/HBoxContainer/Ingredient1Label

@onready var ingredient_2_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient2/MarginContainer/HBoxContainer/Ingredient2Texture
@onready var ingredient_2_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient2/MarginContainer/HBoxContainer/Ingredient2Label

@onready var ingredient_3_texture: TextureRect = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient3/MarginContainer/HBoxContainer/Ingredient3Texture
@onready var ingredient_3_label: RichTextLabel = $CanvasLayer/BottomBar/MarginContainer/HBoxContainer/Ingredient3/MarginContainer/HBoxContainer/Ingredient3Label

var top_coords: Vector2
var bottom_coords: Vector2

var minigame_started: bool = false
var shots_fired: int = 0

var minigame_ended: bool = false

# TODO: load ingredients
# TODO: update ingredients as I chop
# TODO: done! label at the top when ended .. and the recap! and go to the next scene

func _ready() -> void:
	print(GameData.current_fruits)
	top_slider.slider_stopped.connect(start_second_slider)
	bottom_slider.slider_stopped.connect(draw_laser)
	SignalBus.laser_finished_firing.connect(restart_laser)
	SignalBus.laser_fired.connect(update_rounds)
	get_tree().root.size_changed.connect(on_viewport_size_changed)

	GameData.initiate_load_game_data()
	
	if GameData.current[GameData.KEY_CURRENT_MINIGAME] != GameData.Minigames.CHOPPING:
		GameData.current[GameData.KEY_CURRENT_MINIGAME] = GameData.Minigames.CHOPPING
	
	GameData.initiate_save_game_data()
	
	minigame_area.position.x = (get_viewport_rect().size.x/2)-(240/2) 
	cutting_board.spawn_fruit()
	
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		PopupManager.show_popup_dialog("Now you need to chop and grind the Space Fruit. The only reasonable way to do it is by using a Laser Cutting Board (LCB).")
		await PopupManager.next_button_pressed
		PopupManager.show_popup_dialog("Everything you zapped with your Teleportation Gun is inside the LCB. Try to align the laser to chop the all the Space Fruit in the least amount of shots!")

func _input(event):
	if event.is_action_pressed("Interact") and !minigame_started:
		top_message_label.text = "HIT SPACE TO LOCK THE TOP"
		top_slider.start_slider()
		minigame_started = true

func start_second_slider(coords: Vector2) -> void:
	top_coords = coords
	top_message_label.text = "HIT SPACE TO LOCK THE BOTTOM"
	bottom_slider.start_slider()

func draw_laser(coords: Vector2) -> void:
	bottom_coords = coords
	# https://kidscancode.org/godot_recipes/4.x/2d/line_collision/index.html
	laser.set_coords(top_coords, bottom_coords)
	laser.start_laser()
	top_message_label.text = "FIRE!"
	
func restart_laser() -> void:
	top_message_label.text = "HIT SPACE TO START CHOPPING"
	minigame_started = false

func update_rounds() -> void:
	shots_fired += 1
	shots_fired_label.text = str(shots_fired)

#https://forum.godotengine.org/t/how-do-i-detect-when-the-window-is-resized/121381
func on_viewport_size_changed():
	minigame_area.position.x = (get_viewport_rect().size.x/2)-(240/2)
