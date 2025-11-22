extends NavigationRegion2D
class_name Room

@export_category("Handlers")
@export var mob_handler: MobHandler
@export var tilemap: TileMapLayer

@export_category("Other Node References")
@export var goal: Node2D

#func _ready() -> void:
	#mob_handler.set_mob_goal(goal)
	#mob_handler.init_path.call_deferred()
