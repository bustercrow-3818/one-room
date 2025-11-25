extends Node2D



@onready var detection: Area2D = $Area2D
@onready var area_collider: CollisionShape2D = $Area2D/CollisionShape2D

var ready_for_escape: bool = false


func initialize() -> void:
	await get_tree().physics_frame
	connect_signals()
	
func connect_signals() -> void:
	detection.body_entered.connect(escape_reached)
	SignalBus.mob_approaching_escape.connect(allow_escape)
	SignalBus.round_start.connect(start_round)
	
	
	
func escape_reached(body: Node2D) -> void:
	if body is Mob and ready_for_escape:
		SignalBus.escape_reached.emit()
		end_round()

func start_round() -> void:
	ready_for_escape = false

func allow_escape() -> void:
	ready_for_escape = true

func end_round() -> void:
	ready_for_escape = false
