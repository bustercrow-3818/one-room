extends CharacterBody2D
class_name Mob

@export var motion: Node2D
@export var nav_agent: NavigationAgent2D

var goal: Node2D

func set_nav_goal() -> void:
	nav_agent.target_position = goal.global_position
