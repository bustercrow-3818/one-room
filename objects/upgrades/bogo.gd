extends Upgrade

var is_discounted: bool = false
var discard_button: Button

func on_purchase() -> void:
	discard_button = player.discard_button
	SignalBus.approved_purchase.connect(discount_discard)

func discount_discard(id: Node) -> void:
	if id == discard_button and not is_discounted:
		is_discounted = true
		@warning_ignore("integer_division")
		player.adjust_discard_cost(-roundi(player.get_current_discard_cost() / 2))
	else:
		revert_discount()
	
func revert_discount() -> void:
	if is_discounted:
		player.adjust_discard_cost(player.get_current_discard_cost())
