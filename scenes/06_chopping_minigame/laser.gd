extends Node2D

@onready var outer_color: Line2D = $OuterColor
@onready var outer_collision: Area2D = $OuterColor/OuterCollision
@onready var inner_color: Line2D = $InnerColor

var top_coord: Vector2
var bottom_coord: Vector2

func _ready() -> void:
	hide()

func set_coords(top: Vector2, bottom: Vector2) -> void:
	top_coord = top
	bottom_coord = bottom
	
	outer_color.points[0] = to_local(top_coord)
	outer_color.points[1] = to_local(bottom_coord)
	
	inner_color.points[0] = to_local(top_coord)
	inner_color.points[1] = to_local(bottom_coord)
	
	# https://kidscancode.org/godot_recipes/4.x/2d/line_collision/index.html
	for i in outer_color.points.size() - 1:
		var new_shape = CollisionShape2D.new()
		outer_collision.add_child(new_shape)
		var rect = RectangleShape2D.new()
		new_shape.position = (outer_color.points[i] + outer_color.points[i + 1]) / 2
		new_shape.rotation = outer_color.points[i].direction_to(outer_color.points[i + 1]).angle()
		var length = outer_color.points[i].distance_to(outer_color.points[i + 1])
		rect.extents = Vector2(length / 2, outer_color.width / 2)           
		new_shape.shape = rect

func start_laser() -> void:
	show()
	SignalBus.laser_fired.emit()
	await get_tree().create_timer(1.0).timeout
	hide_laser()

func hide_laser() -> void:
	hide()
	if outer_collision.get_child_count() > 0:
		outer_collision.get_child(0).queue_free()
	SignalBus.laser_finished_firing.emit()
