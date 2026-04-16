extends Node2D
class_name SpaceFruit

@onready var grabbing_path: Path2D = $GrabbingPath
@onready var path_follow_2d: PathFollow2D = $GrabbingPath/PathFollow2D
@onready var fruit_collision_full: Area2D = $FruitShape/CollisionChecks/FruitCollisionFull
@onready var fruit_collision_chopped: Area2D = $FruitShape/CollisionChecks/FruitCollisionChopped
@onready var sprite_full: Sprite2D = $FruitShape/Sprites/SpriteFull
@onready var sprite_chopped: Sprite2D = $FruitShape/Sprites/SpriteChopped
@onready var sprite_powder: Sprite2D = $FruitShape/Sprites/SpritePowder
@onready var grabbing_collision: TextureButton = $FruitShape/CollisionChecks/GrabbingCollision
@onready var fruit_shape: Node2D = $FruitShape
@onready var timer: Timer = $Timer

var fruit_type: String
var sprite_full_uri: String
var sprite_chopped_uri: String
var sprite_powder_uri: String
var grabbing_sprite_uri: String
var is_animated: bool = false
var speed: int = 25
var path_complexity: int = 0

enum Statuses {FULL, CHOPPED, GROUNDED}
var status = Statuses.FULL

func _ready() -> void:
	
	timer.wait_time = randf_range(1.5,3.5)
	
	if sprite_full_uri:
		var sprite_full_texture = load(sprite_full_uri)
		sprite_full.texture = sprite_full_texture
		if is_animated == true: sprite_full.hframes = 2
		
	if sprite_chopped_uri:
		var sprite_chopped_texture = load(sprite_chopped_uri)
		sprite_chopped.texture = sprite_chopped_texture
		
	if sprite_powder_uri:
		var sprite_powder_texture = load(sprite_chopped_uri)
		sprite_powder.texture = sprite_powder_texture
		
	if grabbing_sprite_uri:
		var grabbing_texture = load(grabbing_sprite_uri)
		grabbing_collision.texture_normal = grabbing_texture
		# Generate click mask
		var image = grabbing_collision.texture_normal.get_image()
		var bitmap = BitMap.new()
		bitmap.create_from_image_alpha(image)
		grabbing_collision.texture_click_mask = bitmap
		
	set_process(false)

func _process(delta: float) -> void:
	path_follow_2d.progress += delta * speed
	fruit_shape.position = path_follow_2d.position
	if path_follow_2d.progress_ratio >= .99:
		queue_free()

func start_pathing(start_pos: Vector2, end_pos: Vector2) -> void:
	if is_animated == true: timer.start()
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
			# print("Grabbing ", fruit_type)
			SignalBus.fruit_grabbed.emit(fruit_type)
			GameData.current_fruits.append(self)
			reparent(get_node("/root/GameData"))
			set_process(false)
			grabbing_collision.hide()
			reset_transforms()
			hide() #TODO: play zapping animation

func reset_transforms() -> void:
	fruit_shape.position = Vector2.ZERO

func _on_timer_timeout() -> void:
	if sprite_full.frame == 1:
		sprite_full.frame = 0
	elif sprite_full.frame == 0:
		sprite_full.frame = 1
