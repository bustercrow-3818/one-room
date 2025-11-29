extends Node2D
class_name BlockHandler

@export_category("Attributes")
@export var new_round_block_qty: int = 1
@export var default_spawn_position: Vector2
@export var multiple_spawn_offset: Vector2

@export_category("Node References")
@export var block_scenes: Dictionary[String, PackedScene]

var discard_queue: Array[Block]
var next_spawn_pos: Vector2
var ready_for_round: bool = true
var unplaced_blocks: Array[StaticBody2D]

func initialize() -> void:
	for i in get_children():
		if i is StaticBody2D:
			unplaced_blocks.append(i)
	connect_signals()
	create_new_block()
	
func connect_signals() -> void:
	SignalBus.discard_block.connect(discard_new_block)
	SignalBus.end_of_round.connect(end_of_round)
	SignalBus.game_over.connect(game_over)
	pass

func is_ready_for_round() -> bool:
	for i in get_live_blocks():
		var areas: Array[Area2D] = i.get_overlapping_areas()
		
		if areas.is_empty():
			i.play_invalid_animation()
			return false
		
		for j in areas:
			if j.is_in_group("out_of_bounds_area") or j.is_in_group("obstacle"):
				i.play_invalid_animation()
				return false
			else:
				pass
	
	return true

func create_new_block(type: String = "random") -> void: ## Type of block can be designated by name
	var new_block: Block
	
	if get_live_blocks().is_empty():
		next_spawn_pos = default_spawn_position
	
	if type == "random":
		var random_selection_array: Array[PackedScene]
		
		for i in block_scenes.keys():
			random_selection_array.append(block_scenes[i])
		
		new_block = random_selection_array.pick_random().instantiate()
	else:
		new_block = block_scenes[type].instantiate()
	
	call_deferred("add_child", new_block)
	new_block.propagate_call("initialize")
	new_block.position = next_spawn_pos
	next_spawn_pos += multiple_spawn_offset

func get_live_blocks() -> Array[Block]:
	var blocks_live: Array[Block]
	for i in get_children():
		var block: Block = i
		if i is Block:
			block = i
		
		if block.is_block_locked() == false:
			blocks_live.append(i)
	
	return blocks_live

func get_locked_blocks() -> Array[Block]:
	var blocks_locked: Array[Block]
	for i in get_children():
		if i is Block:
			if i.is_block_locked():
				blocks_locked.append(i)
	
	return blocks_locked

func get_blocks() -> Array[Block]:
	var blocks: Array[Block]
	
	for i in get_children():
		if i is Block:
			blocks.append(i)
			
	return blocks

func end_of_round() -> void:
	for i in range(new_round_block_qty):
		await get_tree().physics_frame
		create_new_block()

func discard_new_block() -> void:
	if get_live_blocks().is_empty():
		return
	else:
		discard_queue.append(get_live_blocks().pick_random())
		discard_blocks_in_queue()

func discard_blocks_in_queue() -> void:
	if discard_queue.is_empty():
		return
	else:
		for i in discard_queue:
			i.discard()
			await i.animation.animation_finished
			i.queue_free()
		discard_queue.resize(0)
		
func game_over() -> void:
	discard_queue = get_blocks()
		
	await discard_blocks_in_queue()
	
	SignalBus.discarding_complete.emit()
