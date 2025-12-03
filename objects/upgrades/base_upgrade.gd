extends Node2D
class_name Upgrade

signal purchased
signal unique_upgrade(id: Upgrade)

@export_category("Upgrade Attributes")
@export var unique: bool = false
@export_range(0, 20, 1.0) var cost_to_purchase: int
@export_range(0, 20, 1.0) var other_cost: int
@export var upgrade_name: String
@export_multiline var description: String

@export_category("Node References")
@export var main_button: Button
@export var buy_cancel_container: HBoxContainer
@export var buy: Button
@export var cancel: Button
var player: Player
var block_handler: BlockHandler
var mob_handler: MobHandler
var goal_handler: GoalHandler


func initialize() -> void:
	connect_signals()
	update_upgrade_text()
	update_tooltip()

func connect_signals() -> void:
	main_button.pressed.connect(show_buy_cancel_interface)
	cancel.pressed.connect(hide_buy_cancel_interface)
	buy.pressed.connect(cost_check)

func set_initial_references(p: Player, b: BlockHandler, m: MobHandler, g: GoalHandler) -> void:
	player = p
	block_handler = b
	mob_handler = m
	goal_handler = g

func update_upgrade_text() -> void:
	main_button.text = upgrade_name + "\n\n" + "Cost: " + str(cost_to_purchase)

func update_tooltip() -> void:
	main_button.tooltip_text = description

func on_purchase() -> void: ## Automatically called if the player interface approves a cost check.
	
	pass

func cost_check() -> void: ## Checks the purchase cost again the player's current bits. The player interface will determine whether to buy the upgrade or end the game due to not enough bits.

	SignalBus.cost_check.emit(self, cost_to_purchase)
	
func cost_approved() -> void:
	purchased.emit(self)
	if unique:
		unique_upgrade.emit()
	on_purchase()
	hide_shop_interface()

func show_buy_cancel_interface() -> void:
	buy_cancel_container.show()
	
func hide_buy_cancel_interface() -> void:
	buy_cancel_container.hide()

func hide_shop_interface() -> void:
	for i in get_children():
		i.hide()

func show_shop_interface() -> void:
	for i in get_children():
		i.show()



func is_unique() -> bool:
	return unique
