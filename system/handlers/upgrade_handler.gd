extends Node2D
class_name UpgradeHandler

@export var upgrade_pool: Array[PackedScene]

@export_category("Node References")
@export var player: Player
@export var block_handler: BlockHandler
@export var goal_handler: GoalHandler
@export var mob_handler: MobHandler
@export var buy_sound: AudioStreamPlayer

@export_category("Shop Data")
@export_range(0, 3) var shop_size: int
@export var upgrade_spacing: Vector2

var shop_pool: Array[Upgrade]

func initialize() -> void:
	connect_signals()
	initialize_shop()

func connect_signals() -> void:
	
	pass

func is_ready_for_round() -> bool:
	return true


#region Upgrade creation
func initialize_upgrade(new_upgrade: Upgrade) -> void:
	new_upgrade.set_initial_references(player, block_handler, mob_handler, goal_handler)
	new_upgrade.initialize()

func create_upgrade(upgrade: PackedScene) -> Upgrade:
	var new_upgrade: Upgrade = upgrade.instantiate()
	call_deferred("add_child", new_upgrade)
	initialize_upgrade(new_upgrade)
	new_upgrade.purchased.connect(upgrade_purchased)
	new_upgrade.unique_upgrade.connect(remove_unique_from_pool.bind(upgrade))
	return new_upgrade

func create_random_upgrade() -> Upgrade:
	var new_upgrade_scene = upgrade_pool.pick_random()
	var new_upgrade: Upgrade
	
	new_upgrade = create_upgrade(new_upgrade_scene)
	
	return new_upgrade

func remove_unique_from_pool(id: PackedScene) -> void:
	upgrade_pool.erase(id)


#endregion



#region Shop functions
func initialize_shop() -> void:
	for i in range(shop_size):
		add_upgrade_to_shop(create_random_upgrade())
		await get_tree().physics_frame
	
	update_shop_positions()

func add_upgrade_to_shop(upgrade: Upgrade) -> void:
	shop_pool.append(upgrade)
	
func upgrade_purchased(id: Upgrade) -> void:
	buy_sound.play()
	shop_pool.erase(id)
	add_upgrade_to_shop(create_random_upgrade())
	update_shop_positions()

func update_shop_positions() -> void:
	var current_offset: Vector2 = Vector2.ZERO
	for i in shop_pool:
		i.position = current_offset
		current_offset += upgrade_spacing


#endregion

#region Flair



#endregion
