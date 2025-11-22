extends Node2D
class_name Drag

@export_category("Node References")
@export var mouse_detection_area: Area2D
@export var snap_detection_area: Area2D
var parent: Node2D

@export_category("Characteristics")
@export var state: states = states.IDLE

var mouse_detection: bool = false
var drag_offset: Vector2

enum states {
	IDLE,
	DRAGGING,
	LOCKED
}

func _ready() -> void:
	parent = get_parent()
	mouse_detection_area.mouse_entered.connect(mouse_entered)
	mouse_detection_area.mouse_exited.connect(mouse_exited)
	print("drag_component ready")

func _physics_process(_delta: float) -> void:
	match state:
		states.IDLE:
			idle()
		states.DRAGGING:
			dragging()
		states.LOCKED:
			locked()


func mouse_entered() -> void:
	print("mouse_entered")
	mouse_detection = true
	
func mouse_exited() -> void:
	print("mouse_exited")
	mouse_detection = false

func change_state(new_state: states) -> void:
	state = new_state
	
func idle() -> void:
	if mouse_detection == true and Input.is_action_just_pressed("left_mouse"):
		print("dragging block")
		drag_offset = get_local_mouse_position()
		change_state(states.DRAGGING)
	pass
	
func dragging() -> void:
	parent.global_position = get_global_mouse_position() - drag_offset
	
	if Input.is_action_just_released("left_mouse"):
		snap_to_position()
		print("dropping block")
		change_state(states.IDLE)
	
func locked() -> void:
	pass

func snap_to_position() -> void:
	for i in snap_detection_area.get_overlapping_areas():
		if i.is_in_group("snap_location"):
			parent.position = i.global_position
		else:
			pass
			
	SignalBus.block_snapped.emit()
