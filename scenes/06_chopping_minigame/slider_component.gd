extends Node2D

# https://www.reddit.com/r/gamedev/comments/vvgxus/comment/ifjtpnv/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button

@onready var slider_rect: ColorRect = $SliderRect
@onready var position_rect: ColorRect = $PositionRect
@onready var marker_2d: Marker2D = $PositionRect/Marker2D

@export var speed: int = 100

signal slider_stopped(position: float)

var is_accepting_input: bool = false
var current_position: float = 0.0
var is_sliding: bool = false
enum Directions {RIGHT, LEFT}
var direction := Directions.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match direction:
		Directions.RIGHT:
			current_position += delta*speed
			if current_position > slider_rect.size.x - position_rect.size.x: direction = Directions.LEFT
		Directions.LEFT:
			current_position -= delta*speed
			if current_position < 0: direction = Directions.RIGHT
		
	position_rect.position.x = current_position

func _input(event):
	if is_accepting_input and event.is_action_pressed("Interact") and is_sliding:
		stop_slider()

func start_slider() -> void:
	set_process(true)
	is_accepting_input = true
	is_sliding = true

func stop_slider() -> void:
	set_process(false)
	is_accepting_input = false
	is_sliding = false
	slider_stopped.emit(marker_2d.global_position) #TODO: convert to actual position in middle of slider
