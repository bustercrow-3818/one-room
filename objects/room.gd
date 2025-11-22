extends NavigationRegion2D
class_name Room

@export_category("Handlers")
@export var mob_handler: MobHandler
@export var tilemap: TileMapLayer

@export_category("Other Node References")
@export var goal: Node2D

func _ready() -> void:
	SignalBus.block_snapped.connect(bake_navigation_polygon)
	pass
	
	
func rebake() -> void:
	bake_navigation_polygon()
	pass
