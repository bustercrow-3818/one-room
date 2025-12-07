extends Node

signal block_snapped
signal discard_block
signal discard_waiting
signal discarding_complete
signal discard_specific_block(id: Block)
signal invalid_position

signal cost_check(id: Node, cost: int)
signal approved_purchase(id: Node)

signal round_start
signal end_of_round
signal game_over
signal goal_cleanup(value: int)

signal mob_approaching_escape
signal escape_reached
