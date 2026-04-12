extends Node2D

@export var fruit_scene: PackedScene

@onready var board_area: ColorRect = $BoardArea

func spawn_fruit() -> void:
	for x in 5:
		var fruit = fruit_scene.instantiate()
		fruit.position = Vector2(
			randf_range(0, board_area.size.x),
			randf_range(0, board_area.size.y)
		)
		add_child(fruit)
