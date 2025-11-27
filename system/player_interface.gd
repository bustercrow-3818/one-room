extends Node2D
class_name Player

@export var money: int = 0
@export var score_display: Label

func initialize() -> void:
	adjust_money(0)

func adjust_money(qty: int) -> void:
	money += qty
	score_display.text = str(money)
	
func get_current_money() -> int:
	return money
