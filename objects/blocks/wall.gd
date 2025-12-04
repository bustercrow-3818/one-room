extends StaticBody2D
class_name Block

signal discard_chosen(id: Block)

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $mouse_detection
@onready var mouse_processing: Node2D = $drag_component

@export_category("Stats")
@export_range(0, 1) var glitch_chance: float = 0.12

@export_category("Node References")
@export var lock_line: Line2D
@export var idle_line: Line2D
@export var collision_polygon: CollisionPolygon2D
@export var detection_polygon: CollisionPolygon2D

@export_range(0, 180, 45) var rotation_variation_degrees: int

var awaiting_discard: bool = false
var block_placed_status: bool = false
var locked: bool = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("left_mouse") and mouse_processing.is_mouse_detected() and awaiting_discard:
		SignalBus.discard_specific_block.emit(self)

func initialize() -> void:
	set_initial_rotation()
	connect_signals()
	
func connect_signals() -> void:
	SignalBus.round_start.connect(play_locked_animation)

func set_initial_rotation() -> void:
	rotation_degrees = snappedi(randi_range(0, 360), rotation_variation_degrees)

func is_block_placed() -> bool:
	return block_placed_status

func block_placed() -> void:
	block_placed_status = true

func play_locked_animation() -> void:
	if not locked:
		locked = true
		animation.play("locked_in")
		%locked_sound.play()

func play_invalid_animation() -> void:
	animation.play("invalid")

func play_discard_animation() -> void:
	animation.play("discard")

func play_await_discard_animation() -> void:
	animation.play("await_discard")

func play_reset_animation() -> void:
	animation.play("RESET")

func set_discard_wait_status(status: bool) -> void:
	awaiting_discard = status

func get_overlapping_areas() -> Array[Area2D]:
	return detection_area.get_overlapping_areas()

func is_block_locked() -> bool:
	return locked

func discard() -> void:
	animation.play("discard")
	%discard_sound.play()

func glitch_check(chance: float) -> void:
	var shape_check: float = randf_range(0, 1)
	var spin_check: float = randf_range(0, 1)
	
	if shape_check <= chance:
		glitch_shape()
	
	if spin_check <= chance:
		glitch_rotation()

func glitch_shape() -> void:
	var point_list: Array[Vector2]
	var point_chosen: Vector2
	
	for i in idle_line.points:
		point_list.append(i)
		
	point_chosen = point_list.pick_random()
	
	idle_line.remove_point(idle_line.points.find(point_chosen))
	lock_line.remove_point(lock_line.points.find(point_chosen))
	remove_point_from_polygon(collision_polygon, point_chosen)
	remove_point_from_polygon(detection_polygon, point_chosen)
	
	pass

func remove_point_from_polygon(polygon: CollisionPolygon2D, point: Vector2) -> void:
	var new_points: PackedVector2Array
	
	for i in polygon.polygon:
		if i != point:
			new_points.append(i)
			
	polygon.set_polygon(new_points)

func glitch_rotation() -> void:
	rotation_degrees *= 1 + randf()

func selected_for_discard() -> void:
	discard_chosen.emit(self)

func ready_check() -> bool:
	var status: bool = true
	
	if detection_area.get_overlapping_areas().is_empty():
		status = false
		play_invalid_animation()
		return status
	else:
		pass
	
	for i in detection_area.get_overlapping_areas():
		if i.is_in_group("out_of_bounds_area") or i.is_in_group("obstacle"):
			status = false
			play_invalid_animation()
			return status
		else:
			pass
		
	return status
