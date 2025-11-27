extends StaticBody2D
class_name Block

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $mouse_detection

@export_range(0, 180, 45) var rotation_variation_degrees: int

var block_placed_status: bool = false
var locked: bool = false

func initialize() -> void:
	set_initial_rotation()
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.round_start.connect(play_locked_animation)

func set_initial_rotation() -> void:
	rotation_degrees = snappedi(randi_range(0, 360), rotation_variation_degrees)
	
	if randi_range(1, 4) == 2:
		rotation_degrees *= 1 + randf()
	pass

func is_block_placed() -> bool:
	return block_placed_status

func block_placed() -> void:
	block_placed_status = true

func play_locked_animation() -> void:
	if not locked:
		locked = true
		animation.play("locked_in")
	
func play_invalid_animation() -> void:
	animation.play("invalid")
	
func get_overlapping_areas() -> Array[Area2D]:
	return detection_area.get_overlapping_areas()

func is_block_locked() -> bool:
	return locked
