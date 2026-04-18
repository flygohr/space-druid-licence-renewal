extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var fuel: ProgressBar = $Fuel
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var fuel_consumption: float = 12
var fired_signal_sent: bool = false

@onready var flame_empty_sprite: Sprite2D = $FlameEmptySprite
@onready var flame_begin_sprite: Sprite2D = $FlameBeginSprite
@onready var flame_half_sprite: Sprite2D = $FlameHalfSprite
@onready var flame_full_sprite: Sprite2D = $FlameFullSprite


func _ready() -> void:
	set_process(false)
	flame_empty_sprite.show()
	flame_begin_sprite.hide()
	flame_half_sprite.hide()
	flame_full_sprite.hide()
	area_2d.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	fuel.value -= delta * fuel_consumption
	if fuel.value == 0: 
		SignalBus.rocket_fuel_empty.emit()
		animation_player.play_backwards("firing")
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED 
		set_process(false)

func _input(event):
	if event.is_action_pressed("Interact") and GameData.stirring_ongoing == true and fuel.value > 0:
		set_process(true)
		animation_player.play("firing")
		if fired_signal_sent == false:
			SignalBus.rocket_started.emit()
			fired_signal_sent = true
		area_2d.process_mode = Node.PROCESS_MODE_INHERIT
		
	if event.is_action_released("Interact") and GameData.stirring_ongoing == true and fuel.value > 0:
		animation_player.play_backwards("firing")
		set_process(false)
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
