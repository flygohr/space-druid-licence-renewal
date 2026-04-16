# Script to handle all the signals in the game

extends Node

@warning_ignore_start("unused_signal")

signal pause_game
signal unpause_game

# GRABBING MINIGAME
signal fruit_grabbed(type: String)

# CHOPPING MINIGAME
signal laser_finished_firing
signal chopping_fruit_amt_changed(amt: int)
signal chopping_happened(amt:int)

# STIRRING MINIGAME
signal laps_updated(value: int)
signal rocket_started
signal rocket_fuel_empty

@warning_ignore_restore("unused_signal")
