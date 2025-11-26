extends Node2D
class_name BlockHandler

@export var block_scenes: Dictionary[String, PackedScene]

var ready_for_round: bool = true
var unplaced_blocks: Array[StaticBody2D]

func initialize() -> void:
	for i in get_children():
		if i is StaticBody2D:
			unplaced_blocks.append(i)
	connect_signals()
	
func connect_signals() -> void:
	
	pass

func is_ready_for_round() -> bool:
	for i in get_live_blocks():
		var areas: Array[Area2D] = i.get_overlapping_areas()
		
		if areas.is_empty():
			i.play_invalid_animation()
			return false
		
		for j in areas:
			if j.is_in_group("out_of_bounds_area"):
				i.play_invalid_animation()
				return false
			else:
				pass
	
	return true

func ready_check() -> void:
	pass

func create_new_block(type: String = "random") -> Block: ## Type of block can be designated by name
	var new_block: Block
	
	if type == "random":
		var random_selection_array: Array[PackedScene]
		
		for i in block_scenes.keys():
			random_selection_array.append(block_scenes[i])
		
		new_block = random_selection_array.pick_random().instantiate()
	else:
		new_block = block_scenes[type].instantiate()
	
	call_deferred("add_child", new_block)
	new_block.propagate_call("initialize")
	new_block.position = Vector2(1152, 192)
	new_block.rotation_degrees = snappedi(randi_range(0, 180), 45)
		
	return new_block

func get_live_blocks() -> Array[Block]:
	var blocks_live: Array[Block]
	for i in get_children():
		var block: Block = i
		if i is Block:
			block = i
		
		if block.is_block_locked() == false:
			blocks_live.append(i)
	
	return blocks_live
