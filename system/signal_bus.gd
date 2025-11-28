extends Node

signal block_snapped

signal round_start
signal mob_approaching_escape
signal end_of_round
signal game_over

signal not_ready(message: String)
signal ready_restore(message: String)

signal escape_reached

signal discard_block
