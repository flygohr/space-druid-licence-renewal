extends Node2D

@export var fruit_scene: PackedScene

@onready var spawn_timer: Timer = $SpawnTimer
@onready var time_to_grab: Timer = $TimeToGrab
@onready var time_left_label: Label = $CanvasLayer/TimeLeftLabel
@onready var click_blocker: ColorRect = $CanvasLayer/ClickBlocker


@onready var spawn_path: Path2D = $SpawnPath
@onready var path_follow_2d: PathFollow2D = $SpawnPath/PathFollow2D

var minigame_started: bool = false
var grabbing_enabled: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_process(false)
	time_left_label.text = "HIT SPACE WHEN READY"
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if grabbing_enabled == true:
		time_left_label.text = str("TIME LEFT: %0.2f" % time_to_grab.time_left,"s")

func _input(event):
	if event.is_action_pressed("Interact") and !minigame_started and grabbing_enabled == false:
		minigame_started = true
		set_process(true)
		start_countdown()
	# elif check mouse position for fruit

func start_countdown() -> void:
	spawn_timer.start()
	time_left_label.text = "START IN 3..."
	await get_tree().create_timer(1.0).timeout
	time_left_label.text = "START IN 2..."
	await get_tree().create_timer(1.0).timeout
	time_left_label.text = "START IN 1..."
	await get_tree().create_timer(1.0).timeout
	grabbing_enabled = true
	click_blocker.hide()
	time_to_grab.start()

func spawn_fruit() -> void:
	var new_fruit := fruit_scene.instantiate()
	new_fruit.generate_parameters()
	
	var start_point_ratio: float = randf()
	path_follow_2d.progress_ratio = start_point_ratio
	var start_point_pos: Vector2 = path_follow_2d.global_position
	
	new_fruit.position = start_point_pos
	
	var end_point_ratio: float = randf()
	path_follow_2d.progress_ratio = end_point_ratio
	var end_point_pos: Vector2 = path_follow_2d.global_position
	
	add_child(new_fruit)
	new_fruit.start_pathing(start_point_pos, end_point_pos)

func _on_spawn_timer_timeout() -> void:
	spawn_fruit()
	
func _on_time_to_grab_timeout() -> void:
	spawn_timer.stop()
	click_blocker.show()
	print(GameData.current_fruits)
	await get_tree().create_timer(3.0).timeout
	ScenesManager.load_scene(ScenesConstants.SCENE_PATHS[ScenesConstants.KEY_CHOPPING_MINIGAME])
