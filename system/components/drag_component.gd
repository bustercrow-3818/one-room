extends Node2D
class_name Drag

@export_category("Node References")
@export var mouse_detection_area: Area2D
var parent: Node2D

@export_category("Characteristics")
@export var state: states = states.IDLE
@export var latching: bool = false
@export var snap_distance: int

var mouse_detection: bool = false
var drag_offset: Vector2
var in_discard_zone: bool = false

enum states {
	IDLE,
	DRAGGING,
	LOCKED
}

func initialize() -> void:
	parent = get_parent()
	connect_signals()
	
func connect_signals() -> void:
	mouse_detection_area.mouse_entered.connect(mouse_entered)
	mouse_detection_area.mouse_exited.connect(mouse_exited)
	SignalBus.round_start.connect(change_state.bind(states.LOCKED))
	SignalBus.end_of_round.connect(unlock)

func _physics_process(_delta: float) -> void:
	match state:
		states.IDLE:
			idle()
		states.DRAGGING:
			dragging()
		states.LOCKED:
			locked()

func mouse_entered() -> void:
	mouse_detection = true

func mouse_exited() -> void:
	mouse_detection = false

func change_state(new_state: states) -> void:
	state = new_state
	
func idle() -> void:
	if mouse_detection == true and Input.is_action_just_pressed("left_mouse"):
		drag_offset = parent.global_position - get_global_mouse_position()
		change_state(states.DRAGGING)

func dragging() -> void:
	parent.global_position = get_global_mouse_position() + drag_offset
	
	if Input.is_action_just_released("left_mouse"):
		SignalBus.block_snapped.emit()
		parent.play_placed_sound()
		snap_to_position()
		change_state(states.IDLE)

func locked() -> void:
	pass

func unlock() -> void:
	if not latching and state == states.LOCKED:
		change_state(states.IDLE)

func get_overlapping_areas() -> Array[Area2D]:
	return mouse_detection_area.get_overlapping_areas()

func set_discard_zone_status(status: bool) -> void:
	in_discard_zone = status
	pass

func is_mouse_detected() -> bool:
	if mouse_detection == true:
		return true
	else:
		return false

func snap_to_position() -> void:
	parent.global_position = parent.global_position.snapped(Vector2(snap_distance, snap_distance))
	await get_tree().physics_frame
	parent.ready_check()
