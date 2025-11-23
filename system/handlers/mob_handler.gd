extends Node2D
class_name MobHandler

@export_category("Node References")
@export var round_start_button: Button
@export var escape_point: Node2D

var goal_list: Array[Vector2]
var next_goal: Vector2
var escape: Vector2

func initialize() -> void:
	connect_signals()
	escape = escape_point.global_position
	
	for i in get_children():
		if i.has_method("set_destination"):
			i.new_goal_request.connect(mob_new_goal_path)
			set_next_goal()

	
func connect_signals() -> void:
	pass

func start_round() -> void:
	mob_new_goal_path()
	pass

func mob_path_start() -> void:
	for i in get_children():
		if i is Mob:
			i.path_init()

func set_goals(goals: Array[Vector2]) -> void:
	goal_list = goals.duplicate()

func set_mob_new_goal(goal: Vector2) -> void:
	for i in get_children():
		if i.has_method("set_destination"):
			i.set_destination(goal)

func set_next_goal() -> void:
	if goal_list.is_empty():
		next_goal = escape
		
	else:
		next_goal = goal_list.pick_random()
		goal_list.erase(next_goal)
		
	set_mob_new_goal(next_goal)

func mob_new_goal_path() -> void:
	set_next_goal()
	mob_path_start()
