extends CharacterBody2D
class_name Mob

signal new_goal_request
signal goal_not_reachable

@export_category("Navigation")
@export var nav_agent: NavigationAgent2D
@export var home_position: Vector2

@export_category("Stats")
@export var speed: float = 1000
@export var hp: int = 100

@export_category("System Data")
@export var no_path_message: String

@export_category("Testing")
@export var test_mob_ref: Mob

var next_goal: Vector2

func initialize() -> void:
	connect_signals()
	home_position = global_position

func connect_signals() -> void:
	nav_agent.target_reached.connect(goal_reached)
	
func path_init() -> void:
	await get_tree().physics_frame
	
	set_movement_target(next_goal)
	
func set_movement_target(movement_target: Vector2) -> void:
	nav_agent.target_position = movement_target

func set_destination(destination: Vector2) -> void:
	next_goal = destination

func set_new_velocity() -> void:
	var current_position: Vector2 = global_position
	var next_position: Vector2 = nav_agent.get_next_path_position()
	
	velocity = current_position.direction_to(next_position) * speed

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
		
	set_new_velocity()
	move_and_slide()

func goal_reached() -> void:
	new_goal_request.emit()
