extends Node2D

# when ready, start the minigame
# start top slider
# when top slider is set, get its position and start second slider
# when both coords are set, draw cut line
# then calculate score to later add to globals

@onready var top_slider: Node2D = $TopSlider
@onready var bottom_slider: Node2D = $BottomSlider
@onready var laser: Node2D = $Laser
@onready var cutting_board: Node2D = $"Cutting board"

@onready var fruits_left_label: Label = $FruitsLeftLabel
@onready var grounded_percent_label: Label = $GroundedPercentLabel
@onready var rounds_left_label: Label = $RoundsLeftLabel

var top_coords: Vector2
var bottom_coords: Vector2

var minigame_started: bool = false
var rounds: int = 5:
	set(new_value):
		rounds = new_value
		update_rounds_left(new_value)

var minigame_ended: bool = false

func _ready() -> void:
	print(GameData.current_fruits)
	top_slider.slider_stopped.connect(start_second_slider)
	bottom_slider.slider_stopped.connect(draw_laser)
	SignalBus.laser_finished_firing.connect(restart_laser)
	SignalBus.chopping_fruit_amt_changed.connect(update_fruit_amount)
	SignalBus.chopping_happened.connect(update_grounded_percent)
	cutting_board.spawn_fruit()

func _input(event):
	if event.is_action_pressed("Interact") and !minigame_started and rounds > 0:
		top_slider.start_slider()
		minigame_started = true
		rounds -= 1
	if event.is_action_pressed("Interact") and !minigame_started and rounds == 0:
		ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_STIRRING_MINIGAME])

func start_second_slider(coords: Vector2) -> void:
	top_coords = coords
	bottom_slider.start_slider()

func draw_laser(coords: Vector2) -> void:
	bottom_coords = coords
	# https://kidscancode.org/godot_recipes/4.x/2d/line_collision/index.html
	laser.set_coords(top_coords, bottom_coords)
	laser.start_laser()
	
func restart_laser() -> void:
	if GameData.current_fruits_amount > 0:
		minigame_started = false
	else: print("No more to cut")

func update_fruit_amount(amt: int) -> void:
	fruits_left_label.text = str("FRUITS LEFT: ", amt)
	
func update_rounds_left(amt: int) -> void:
	rounds_left_label.text = str("ROUNDS LEFT: ", amt)

func update_grounded_percent(amt: int) -> void:
	var grounded_percent: float = snapped((float(amt)/(GameData.total_fruits_amount*3))*100, 0.01)
	grounded_percent_label.text = str("GROUNDED: ", grounded_percent, "%")
