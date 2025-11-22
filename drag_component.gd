extends Node2D
class_name Drag

@export_category("Node References")
@export var mouse_detection_area: Area2D
@export var snap_detection_area: Area2D
@export var parent: Node2D

@export_category("Characteristics")
@export var state: states = states.IDLE

var mouse_detection: bool = false

enum states {
	IDLE,
	DRAGGING,
	LOCKED
}

func _ready() -> void:
	mouse_detection_area.mouse_entered.connect(mouse_entered)
	mouse_detection_area.mouse_exited.connect(mouse_exited)

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
		change_state(states.DRAGGING)
	pass
	
func dragging() -> void:
	parent.global_position = get_global_mouse_position()
	
	if Input.is_action_just_released("left_mouse"):
		snap_to_position()
		change_state(states.IDLE)
	
func locked() -> void:
	pass

func snap_to_position() -> void:
	
	pass
