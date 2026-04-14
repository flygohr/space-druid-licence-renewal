extends Node2D

@onready var grabbing_path: Path2D = $GrabbingPath
@onready var path_follow_2d: PathFollow2D = $GrabbingPath/PathFollow2D
@onready var fruit_collision_full: Area2D = $FruitShape/CollisionChecks/FruitCollisionFull
@onready var fruit_collision_chopped: Area2D = $FruitShape/CollisionChecks/FruitCollisionChopped
@onready var sprite_full: Sprite2D = $FruitShape/Sprites/SpriteFull
@onready var sprite_chopped: Sprite2D = $FruitShape/Sprites/SpriteChopped
@onready var sprite_powder: Sprite2D = $FruitShape/Sprites/SpritePowder
@onready var grabbing_collision: ColorRect = $FruitShape/CollisionChecks/GrabbingCollision

@onready var fruit_shape: Node2D = $FruitShape

enum Types {
	KIDNEY_GRAPES,
	HEART_DRAGON_FRUIT,
	ROTTEN_BANANA
}
enum Statuses {FULL, CHOPPED, GROUNDED}

var speed: int = 25
var type := Types.KIDNEY_GRAPES

var status = Statuses.FULL

func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	path_follow_2d.progress += delta * speed
	fruit_shape.position = path_follow_2d.position
	if path_follow_2d.progress_ratio >= .99:
		queue_free()
		
func generate_parameters() -> void:
	var type_picker = randf()
	if type_picker >= 0.6 and type_picker < 0.8:
		type = Types.HEART_DRAGON_FRUIT
	elif type_picker >= 0.8:
		type = Types.ROTTEN_BANANA
		
	match type:
		Types.HEART_DRAGON_FRUIT:
			$FruitShape/Sprites/SpriteFull.modulate = Color(0.487, 0.176, 0.176, 1.0)
			speed *= 3
		Types.ROTTEN_BANANA:
			$FruitShape/Sprites/SpriteFull.modulate = Color(0.447, 0.485, 0.152, 1.0)
			speed *= 2

func start_pathing(start_pos: Vector2, end_pos: Vector2) -> void:
	var new_curve: Curve2D = Curve2D.new()
	new_curve.add_point(to_local(start_pos))
	new_curve.add_point(to_local(end_pos))
	
	grabbing_path.curve = new_curve
	set_process(true)

func _on_fruit_collision_full_area_entered(area: Area2D) -> void:
	if area.is_in_group("LaserBeam") and status == Statuses.FULL:
		sprite_full.hide()
		sprite_chopped.show()
		GameData.current_chopped_hits += 1

func _on_fruit_collision_chopped_area_entered(area: Area2D) -> void:
	if area.is_in_group("LaserBeam") and status == Statuses.CHOPPED:
		sprite_chopped.hide()
		sprite_powder.show()
		GameData.current_chopped_hits += 1
		GameData.current_fruits_amount -= 1

func _on_fruit_collision_full_area_exited(area: Area2D) -> void:
	if area.is_in_group("LaserBeam") and status == Statuses.FULL:
		fruit_collision_full.hide()
		fruit_collision_chopped.show()
		status = Statuses.CHOPPED

func _on_color_rect_gui_input(event: InputEvent) -> void:
		if event.is_action_pressed("Grab"):
			print("Grabbing")
			GameData.current_fruits.append(self)
			reparent(get_node("/root/GameData"))
			set_process(false)
			grabbing_collision.hide()
			reset_transforms()
			hide()

func reset_transforms() -> void:
	fruit_shape.position = Vector2.ZERO
