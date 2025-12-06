extends Node2D
class_name Goal

signal goal_picked_up(goal_id: Goal)

signal earned_by_player
signal earned_by_mob

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var pickup_sound: AudioStreamPlayer = $AudioStreamPlayer
@onready var area: Area2D = $Area2D

@export var player_reward: int
@export var penalty: int

var pitch_mod: float = 1
var ready_to_pickup: bool = true

func connect_signals() -> void:
	area.body_entered.connect(is_mob_detected)
	SignalBus.end_of_round.connect(reward_animation.bind(false))

func is_mob_detected(body: Node2D) -> void:
	if ready_to_pickup and body is Mob:
		pickup_sound.play()
		goal_picked_up.emit(self)

func is_ready_to_pickup() -> bool:
	return ready_to_pickup

func set_pickup_ready_status(status: bool) -> void:
	ready_to_pickup = status

func set_pickup_pitch(mod: float) -> void:
	pickup_sound.pitch_scale += mod

func reset_animation() -> void:
	animation.play("RESET")

func reward_animation(forward: bool = true) -> void:
	if not forward:
		animation.play_backwards("reward")
	else:
		animation.play("reward")

func penalty_animation(forward: bool = true) -> void:
	if not forward:
		animation.play_backwards("penalty")
	else:
		animation.play("penalty")
	%discard_sound.play()

func end_of_round() -> void:
	pickup_sound.pitch_scale = 1
	reward_animation(false)
