extends Node2D
class_name Player

@export var money: int = 5

func adjust_money(qty: int) -> void:
	money += qty
	print(money)
	
func get_current_money() -> int:
	return money
