extends Node2D

@onready var zapping_stats: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Zapping/ZappingStats
@onready var zapping_grade: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Zapping/ZappingGrade
@onready var chopping_stats: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Chopping/ChoppingStats
@onready var chopping_grade: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Chopping/ChoppingGrade
@onready var stirring_stats: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Stirring/StirringStats
@onready var stirring_grade: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/Stirring/StirringGrade

@onready var result_label: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/NinePatchRect/MarginContainer/VBoxContainer/ResultLabel

func _ready() -> void:
	GameData.current[GameData.KEY_IS_NEW_GAME] = false
	GameData.initiate_save_game_data()
	
	zapping_stats.text = str(
		"ZAPPING: ", round_to_dec(GameData.current[GameData.KEY_GRABBING_TIME],2),
		"s, JUNK: ", GameData.current[GameData.KEY_GRABBING_JUNK_AMT]
	)
	var zapping_grade_int: int = GameData.calculate_grabbing_grade()
	var zapping_grade_string: String = match_grade(zapping_grade_int)
	zapping_grade.text = zapping_grade_string
	
	chopping_stats.text = str(
		"LASERS FIRED: ",
		GameData.current[GameData.KEY_SHOTS_FIRED]
	)
	var chopping_grade_int: int = GameData.calculate_chopping_grade()
	var chopping_grade_string: String = match_grade(chopping_grade_int)
	chopping_grade.text = chopping_grade_string
	
	stirring_stats.text = str(
		"LADLE SPINS: ",
		GameData.current[GameData.KEY_REVOLUTIONS_DONE]
	)
	var stirring_grade_int: int = GameData.calculate_stirring_grade()
	var stirring_grade_string: String = match_grade(stirring_grade_int)
	stirring_grade.text = stirring_grade_string
	
	if GameData.calculate_final_grade() == "F":
		result_label.text = "LICENCE RENEWAL FAILED"
	else:
		result_label.text = "LICENCE RENEWED"

func _on_continue_button_pressed() -> void:
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_ASSIGNMENT_SCREEN])

# https://forum.godotengine.org/t/how-to-round-to-a-specific-decimal-place/27552/2
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
	
func match_grade(grade: int) -> String:
	match grade:
		1: return "S+"
		2: return "S"
		3: return "A"
		4: return "B"
		5: return "C"
		6: return "D"
		_: return "F"
