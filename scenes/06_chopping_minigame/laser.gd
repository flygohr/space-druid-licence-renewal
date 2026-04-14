extends Node2D

@onready var line_2d: Line2D = $Line2D
@onready var static_body_2d: Area2D = $Line2D/StaticBody2D

var top_coord: Vector2
var bottom_coord: Vector2

func _ready() -> void:
	hide()

func set_coords(top: Vector2, bottom: Vector2) -> void:
	top_coord = top
	bottom_coord = bottom
	
	line_2d.points[0] = top_coord
	line_2d.points[1] = bottom_coord
	
	# https://kidscancode.org/godot_recipes/4.x/2d/line_collision/index.html
	for i in line_2d.points.size() - 1:
		var new_shape = CollisionShape2D.new()
		static_body_2d.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (line_2d.points[i] + line_2d.points[i + 1]) / 2
		new_shape.rotation = line_2d.points[i].direction_to(line_2d.points[i + 1]).angle()
		var length = line_2d.points[i].distance_to(line_2d.points[i + 1])
		rect.extents = Vector2(length / 2, line_2d.width / 2)
		new_shape.shape = rect

func start_laser() -> void:
	show()
	await get_tree().create_timer(1.0).timeout
	hide_laser()

func hide_laser() -> void:
	hide()
	if static_body_2d.get_child_count() > 0:
		static_body_2d.get_child(0).queue_free()
	SignalBus.laser_finished_firing.emit()
