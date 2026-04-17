extends Node2D

@export var fruit_scene: PackedScene

@onready var board_area: ColorRect = $BoardArea

func spawn_fruit() -> void:
	# get current level ingredients
	# for each ingredient, spawn the correct fruit
	var current_level: int = GameData.current[GameData.KEY_CURRENT_LEVEL]
	
	var current_first_ingredient_name = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][1][GameData.KEY_FRUIT_NAME]
	var current_first_ingredient_qty = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][1][GameData.KEY_QTY]
	
	var current_second_ingredient_name = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][2][GameData.KEY_FRUIT_NAME]
	var current_second_ingredient_qty = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][2][GameData.KEY_QTY]

	var current_third_ingredient_name = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][3][GameData.KEY_FRUIT_NAME]
	var current_third_ingredient_qty = GameData.LEVELS[current_level][GameData.KEY_REQUIREMENTS][3][GameData.KEY_QTY]
	
	var fruit_to_spawn: Array = []
	for x in current_first_ingredient_qty: fruit_to_spawn.append(current_first_ingredient_name)
	for x in current_second_ingredient_qty: fruit_to_spawn.append(current_second_ingredient_name)
	for x in current_third_ingredient_qty: fruit_to_spawn.append(current_third_ingredient_name)
	
	for fruit in fruit_to_spawn:
		var new_fruit := fruit_scene.instantiate()
		var picked_fruit = fruit #TODO: weighted random
		
		#instead of calling a function here, set parameters as variables
		new_fruit.fruit_type = str(picked_fruit)
		print("Spawning ", picked_fruit)
		new_fruit.sprite_full_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.MAIN_TEXTURE]
		new_fruit.sprite_chopped_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.CHOPPED_TEXTURE]
		new_fruit.grabbing_sprite_uri = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SINGLE_TEXTURE]
		new_fruit.is_animated = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.IS_ANIMATED]
		new_fruit.speed = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.SPEED]
		new_fruit.path_complexity = GameData.FRUIT_DATA[picked_fruit][GameData.FruitParams.PATH_COMPLEXITY]
		
		new_fruit.position = to_global(Vector2(
			int(randf_range(board_area.position.x, board_area.position.x+board_area.size.x)),
			int(randf_range(board_area.position.y, board_area.position.y+board_area.size.y))
		))
		add_child(new_fruit)
		new_fruit.show()
		GameData.total_fruits_amount += 1
		GameData.current_fruits_amount = GameData.total_fruits_amount
