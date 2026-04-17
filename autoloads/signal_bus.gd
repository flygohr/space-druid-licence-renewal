# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal unpause_game

# GRABBING MINIGAME
signal fruit_grabbed(type: String)
signal spawn_fruit

# CHOPPING MINIGAME
signal laser_fired
signal laser_finished_firing
signal fruit_chopped(type: String)

# STIRRING MINIGAME
signal laps_updated(value: int)
signal rocket_started
signal rocket_fuel_empty

@warning_ignore_restore("unused_signal")
