extends Node2D

var impact: float = 0.4
var velocity: float
var min_velocity: float = 0.01
var max_velocity: float = 10
var min_rotation: float = 0.0
var max_rotation: float = 0.5
var drag: float = 0.01

var accelerating: bool = false
var rotate_amt: float
var laps: int = 0:
	set(new_value):
		laps = new_value
		SignalBus.laps_updated.emit(new_value)

func _ready() -> void:
	SignalBus.rocket_fuel_empty.connect(stop_rotation)
	SignalBus.rocket_started.connect(set_minimum_rotation)

func _process(delta: float) -> void:
	match accelerating:
		true: 
			velocity = clampf(velocity + (impact * delta), min_velocity, max_velocity)
			rotate_amt += velocity * delta
		false:
			velocity = clampf(velocity - (impact * delta), min_velocity, max_velocity)
			rotate_amt -= velocity * (impact * delta)
	rotate_amt = clampf(rotate_amt, min_rotation, max_rotation)
	rotate(rotate_amt)
	laps = int(rotation_degrees/360)

func _on_ladle_collision_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("RocketFire"):
		accelerating = true

func _on_ladle_collision_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("RocketFire"):
		accelerating = false

func stop_rotation() -> void:
	drag = 100
	impact = 5
	min_rotation = 0

func set_minimum_rotation() -> void:
	min_rotation = 0.01
