extends Node2D
class_name Debugger

@onready var debugger_label: Label = $DebuggerLabel

const MAX_MESSAGES: int = 10
var debug_messages: Array = []
var output_string: String = ""

func _ready() -> void:
	add_line(str("OS name: ", OS.get_name()))

func add_line(s: String) -> void:
	output_string = ""
	debug_messages.append(s)
	print(debug_messages.size())
	if debug_messages.size() > MAX_MESSAGES: debug_messages.pop_front()
	for line in debug_messages:
		output_string += str(line, "\n")
	debugger_label.text = output_string
