extends Node2D
class_name MobHandler

@export_category("Node References")
@export var round_start_button: Button
@export var escape_point: Node2D

var ready_for_round: bool = true
var goal_list: Array[Vector2]
var next_goal: Vector2
var escape: Vector2

func initialize() -> void:
	connect_signals()
	escape = escape_point.global_position
	
	for i in get_children():
		if i.has_method("set_destination"):
			i.new_goal_request.connect(set_next_goal)
	
	await get_tree().physics_frame
	
func connect_signals() -> void:

	pass

func start_round() -> void:
	set_next_goal()
	
	for i in get_children():
		if i is Mob:
			i.ready_to_move = true

#region Setters
func set_goals(goals: Array[Vector2]) -> void:
	goal_list = goals.duplicate()

func set_mob_new_goal(goal: Vector2) -> void:
	for i in get_children():
		if i.has_method("set_destination"):
			i.set_destination(goal)

func set_next_goal() -> void:
	if goal_list.is_empty():
		next_goal = escape
		SignalBus.mob_approaching_escape.emit()
		
	else:
		next_goal = goal_list.pick_random()
		goal_list.erase(next_goal)
	
	set_mob_new_goal(next_goal)

#endregion

func ready_check() -> void:
	
	pass
	
#region Getters
func is_ready_for_round() -> bool:
	
	
	return ready_for_round

#endregion
