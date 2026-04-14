extends Node2D

@export var fruit_scene: PackedScene

@onready var board_area: ColorRect = $BoardArea

func spawn_fruit() -> void:
	for fruit in GameData.current_fruits:
		fruit.reparent(self)
		fruit.position = Vector2(
			randf_range(0, board_area.size.x),
			randf_range(0, board_area.size.y)
		)
		fruit.show()
		GameData.total_fruits_amount += 1
		GameData.current_fruits_amount = GameData.total_fruits_amount
