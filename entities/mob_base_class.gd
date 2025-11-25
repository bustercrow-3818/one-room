extends CharacterBody2D
class_name Mob

signal new_goal_request
signal goal_not_reachable

@export_category("Navigation")
@export var nav_agent: NavigationAgent2D
@export var path_check: NavigationAgent2D
@export var home_position: Vector2

@export_category("Stats")
@export var speed: float = 1000
@export var hp: int = 100

var goals: Array[Vector2]
var next_goal: Vector2
var round_started: bool = false

func initialize() -> void:
	connect_signals()
	home_position = global_position

func connect_signals() -> void:
	nav_agent.target_reached.connect(goal_reached)
	
func path_init() -> void:
	await get_tree().physics_frame
	
	set_movement_target(next_goal)

#region Setters
func set_goals(goals_list: Array[Vector2]) -> void:
	goals = goals_list.duplicate()

func set_movement_target(movement_target: Vector2) -> void:
	nav_agent.target_position = movement_target
	
	if nav_agent.is_target_reachable():
		pass
	else:
		new_goal_request.emit()
		

func set_destination(destination: Vector2) -> void:
	next_goal = destination
	path_init()

func set_new_velocity() -> void:
	var current_position: Vector2 = global_position
	var next_position: Vector2 = nav_agent.get_next_path_position()
	
	velocity = current_position.direction_to(next_position) * speed
	
#endregion

#region Getters

func is_path_valid() -> bool:
	var map_rid: RID
	var path_array: Array[Vector2]
	
	for i in goals:
		path_check.target = i
		await get_tree().physics_frame
		
		map_rid = path_check.get_navigation_map()
		path_array = NavigationServer2D.map_get_path(map_rid, global_position, i, true)
		
		if path_array.size() == 0:
			return false
		elif path_array[-1] != i:
			return false
		else:
			return true
	return true

func get_path_validity() -> bool:
	var test: bool
	var map_rid = nav_agent.get_navigation_map()
	var path_array = NavigationServer2D.map_get_path(map_rid, global_position, next_goal, true)
	
	if path_array[-1] != next_goal:
		test = false
	else:
		test = true
	
	return test

func is_target_reachable(target: Vector2) -> bool:
	nav_agent.target_position = target
	
	if nav_agent.is_target_reachable():
		return true
	else:
		return false
#endregion

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
	
	if round_started:
		set_new_velocity()
		move_and_slide()

func goal_reached() -> void:
	new_goal_request.emit()
