extends Node2D

@onready var assignment_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/AssignmentLabel

@onready var ingredient_1_icon: TextureRect = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/PanelContainer/Ingredient_1_Icon
@onready var ingredient_1_qty_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Ingredient_1_Qty
@onready var ingredient_1_name_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer/MarginContainer/HBoxContainer/Ingredient_1_Name

@onready var ingredient_2_icon: TextureRect = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/PanelContainer/Ingredient_2_Icon
@onready var ingredient_2_qty_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/Ingredient_2_Qty
@onready var ingredient_2_name_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer2/MarginContainer/HBoxContainer/Ingredient_2_Name

@onready var ingredient_3_icon: TextureRect = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/PanelContainer/Ingredient_3_Icon
@onready var ingredient_3_qty_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/Ingredient_3_Qty
@onready var ingredient_3_name_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect2/MarginContainer/VBoxContainer/PanelContainer3/MarginContainer/HBoxContainer/Ingredient_3_Name

func _ready() -> void:
	if GameData.current[GameData.KEY_IS_NEW_GAME] == true:
		play_tutorial()
		
	assignment_label.text = str(
		"Assignment #",
		GameData.current[GameData.KEY_CURRENT_LEVEL],
		" ingredients:"
	).to_upper()
	
	var ingredient_1_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_FRUIT_NAME]
	var ingredient_1_icon_file = load(GameData.FRUIT_DATA[ingredient_1_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_1_icon.texture = ingredient_1_icon_file
	var ingredient_1_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][1][GameData.KEY_QTY]
	ingredient_1_qty_label.text = str(ingredient_1_qty, "x")
	ingredient_1_name_label.text = ingredient_1_name.to_upper()
	
	var ingredient_2_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_FRUIT_NAME]
	var ingredient_2_icon_file = load(GameData.FRUIT_DATA[ingredient_2_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_2_icon.texture = ingredient_2_icon_file
	var ingredient_2_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][2][GameData.KEY_QTY]
	ingredient_2_qty_label.text = str(ingredient_2_qty, "x")
	ingredient_2_name_label.text = ingredient_2_name.to_upper()
	
	var ingredient_3_name = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_FRUIT_NAME]
	var ingredient_3_icon_file = load(GameData.FRUIT_DATA[ingredient_3_name][GameData.FruitParams.SINGLE_TEXTURE]) 
	ingredient_3_icon.texture = ingredient_3_icon_file
	var ingredient_3_qty = GameData.LEVELS[GameData.current[GameData.KEY_CURRENT_LEVEL]][GameData.KEY_REQUIREMENTS][3][GameData.KEY_QTY]
	ingredient_3_qty_label.text = str(ingredient_3_qty, "x")
	ingredient_3_name_label.text = ingredient_3_name.to_upper()

func play_tutorial() -> void:
	# generate protocol number to be referenced later
	var random_number: int = randi()
	var protocol_letters: Array = "abcdefghijklmnopqrstuvwxyz".split()
	var protocol_number: String = str(
		protocol_letters.pick_random().to_upper(),
		protocol_letters.pick_random().to_upper(),
		"-",
		random_number
	)
	
	PopupManager.show_popup_dialog(str(
		"Dear Space Druid, your Operating Licence ",
		protocol_number,
		" is expiring soon."
		))
	await PopupManager.next_button_pressed
	GameData.current[GameData.KEY_PROTOCOL_NUMBER] = protocol_number
	
	PopupManager.show_popup_dialog("To renew your Operating Licence, you will need to complete Assignments for the Galactic Druid Guild (GDG).")
	await PopupManager.next_button_pressed
	
	PopupManager.show_popup_dialog("Each Assignment will consist of the making of 1 (ONE) batch of Space Potions, using a given list of Space Fruit.")
	await PopupManager.next_button_pressed
	
	var total_assignments: int = GameData.LEVELS.size()
	
	PopupManager.show_popup_dialog(str("You will be graded on the result of each Assignment. Complete the required ", total_assignments, " Assignments to renew you Licence."))
	await PopupManager.next_button_pressed
	
	PopupManager.show_popup_dialog("Please proceed to your first Assignment and familiarize with the ingredients list.", "Start")
	await PopupManager.next_button_pressed

func _on_start_button_pressed() -> void:
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_GRABBING_MINIGAME])
