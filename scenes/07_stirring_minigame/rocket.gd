extends Node2D

@onready var flame_sprite: Sprite2D = $FlameSprite
@onready var area_2d: Area2D = $FlameSprite/Area2D
@onready var fuel: ProgressBar = $Fuel

var fuel_consumption: float = 12
var fired_signal_sent: bool = false

func _ready() -> void:
	set_process(false)
	flame_sprite.hide()
	area_2d.process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	flame_sprite.show()
	fuel.value -= delta * fuel_consumption
	if fuel.value == 0: 
		SignalBus.rocket_fuel_empty.emit()
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		flame_sprite.hide()

func _input(event):
	if event.is_action_pressed("Interact") and GameData.stirring_ongoing == true and fuel.value > 0:
		set_process(true)
		if fired_signal_sent == false:
			SignalBus.rocket_started.emit()
			fired_signal_sent = true
		area_2d.process_mode = Node.PROCESS_MODE_INHERIT
		
	if event.is_action_released("Interact") and GameData.stirring_ongoing == true and fuel.value > 0:
		set_process(false)
		area_2d.process_mode = Node.PROCESS_MODE_DISABLED
		flame_sprite.hide()
