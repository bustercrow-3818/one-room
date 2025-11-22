extends CharacterBody2D
class_name Mob


@export_category("Navigation")
@export var nav_agent: NavigationAgent2D
var goal: Node2D

@export_category("Stats")
@export var speed: float = 1000
@export var hp: int = 100

@export_category("Testing")
@export var test_mob_ref: Mob
@export var target_destination: Vector2

func _ready() -> void:
	path_init.call_deferred()
	SignalBus.block_snapped.connect(set_movement_target.bind(target_destination))
	
func path_init() -> void:
	await get_tree().physics_frame
	
	set_movement_target(target_destination)
	
func set_movement_target(movement_target: Vector2) -> void:
	nav_agent.target_position = movement_target

func set_new_velocity() -> void:
	var current_position: Vector2 = global_position
	var next_position: Vector2 = nav_agent.get_next_path_position()
	
	velocity = current_position.direction_to(next_position) * speed

func _physics_process(_delta: float) -> void:
	if nav_agent.is_navigation_finished():
		return
		
	set_new_velocity()
	move_and_slide()
