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
			i.new_goal_request.connect(mob_new_goal_path)
	
	set_next_goal()
	await get_tree().physics_frame
	test_path_validity()
	
func connect_signals() -> void:
	SignalBus.block_snapped.connect(test_path_validity)
	pass

func test_path_validity() -> void:
	await get_tree().physics_frame
	
	var test_mob: Mob = get_child(0)
	
	if await test_mob.is_path_valid():
		ready_for_round = true
	else:
		ready_for_round = false
	
	ready_for_round = await test_mob.is_path_valid()

func start_round() -> void:
	mob_new_goal_path()
	
	for i in get_children():
		if i is Mob:
			i.round_started = true

#func mob_path_start() -> void:
	#for i in get_children():
		#if i is Mob:
			#i.path_init()

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
		
	else:
		next_goal = goal_list.pick_random()
		goal_list.erase(next_goal)
		
	set_mob_new_goal(next_goal)

#endregion

#region Getters
func is_ready_for_round() -> bool:
	return ready_for_round

#endregion

func mob_new_goal_path() -> void:
	set_next_goal()
	#mob_path_start()
