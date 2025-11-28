extends StaticBody2D
class_name Block

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var detection_area: Area2D = $mouse_detection

@export_category("Stats")
@export_range(0, 1) var glitch_chance: float = 0.08

@export_category("Node References")
@export var lock_line: Line2D
@export var idle_line: Line2D
@export var collision_polygon: CollisionPolygon2D
@export var detection_polygon: CollisionPolygon2D

@export_range(0, 180, 45) var rotation_variation_degrees: int

var block_placed_status: bool = false
var locked: bool = false

func initialize() -> void:
	set_initial_rotation()
	connect_signals()
	glitch_check()
	
func connect_signals() -> void:
	SignalBus.round_start.connect(play_locked_animation)
	SignalBus.discard_block.connect(discard)

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
	
func play_invalid_animation() -> void:
	animation.play("invalid")

func play_discard_animation() -> void:
	animation.play("discard")
	
	
func get_overlapping_areas() -> Array[Area2D]:
	return detection_area.get_overlapping_areas()

func is_block_locked() -> bool:
	return locked

func discard() -> void:
	if not locked:
		animation.play("discard")
		%discard_sound.play()
		await animation.animation_finished
		queue_free()

func glitch_check() -> void:
	var shape_check: float = randf_range(0, 1)
	var spin_check: float = randf_range(0, 1)
	
	if shape_check <= glitch_chance:
		glitch_shape()
	
	if spin_check <= glitch_chance:
		glitch_rotation()
	pass
	
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
