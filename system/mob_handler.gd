extends Node2D
class_name MobHandler

func initialize() -> void:
	
	pass

func set_mob_goal(node: Node2D) -> void:
	for i in get_children():
		if i is Mob:
			i.goal = node
			i.set_nav_goal()
