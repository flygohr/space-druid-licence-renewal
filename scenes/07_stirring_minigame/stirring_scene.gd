extends Node2D
@onready var laps_label: Label = $LapsLabel

func _ready() -> void:
	SignalBus.laps_updated.connect(update_laps)

func _input(event):
	if event.is_action_pressed("Interact"):
		GameData.stirring_ongoing = true

func update_laps(value: int) -> void:
	laps_label.text = str("STIRS: ", value)
