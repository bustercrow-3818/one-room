extends Node

signal block_snapped
signal goal_cleanup(value: int)
signal cost_check(id: Node, cost: int)
signal bits_spent(value: int)
signal round_start
signal mob_approaching_escape
signal end_of_round
signal game_over
signal not_ready(message: String)
signal ready_restore(message: String)
signal escape_reached
signal discard_block
signal discarding_complete
