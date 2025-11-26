extends Node2D

signal end_of_round

@export var player: Player

var ready_for_round: bool = true
var active_goals: Array[Goal]

func initialize() -> void:
	for i in get_children():
		if i is Goal:
			active_goals.append(i)
		
		if i.has_method("initialize"):
			i.initialize()
		else:
			pass
			
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.escape_reached.connect(end_round_cleanup)
	SignalBus.round_start.connect(start_round)
	
	for i in active_goals:
		i.connect_signals()
		i.goal_picked_up.connect(mob_pickup)

func start_round() -> void:
	for i in active_goals:
		i.set_pickup_ready_status(true)
		i.reset_animation()

func get_goals() -> Array[Vector2]:
	var goals: Array[Vector2]
	
	for i in get_children():
		goals.append(i.position)
	
	return goals

func ready_check() -> void:
	
	pass

func is_ready_for_round() -> bool:
	return ready_for_round

func end_round_cleanup() -> void:
	for i in active_goals:
		if i is Goal and i.is_ready_to_pickup():
			i.penalty_animation()
			player.adjust_money(-1)
			await i.animation.animation_finished
			
	SignalBus.end_of_round.emit()

func mob_pickup(goal_id: Goal) -> void:
	if goal_id.is_ready_to_pickup():
		goal_id.set_pickup_ready_status(false)
		goal_id.reward_animation()
		player.adjust_money(1)
