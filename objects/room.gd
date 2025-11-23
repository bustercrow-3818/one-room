extends NavigationRegion2D
class_name Room

func initialize() -> void:
	bake_navigation_polygon()
	connect_signals()

func connect_signals() -> void:
	SignalBus.block_snapped.connect(bake_navigation_polygon)
