## Visually displays how much the player has moved a particular character on a given turn. This
## will help with seeing how much they can move before it will cost an action point.
class_name UnitMoveAmountDisplayer extends PanelContainer

## The visual element that will display the movement.
@export var progress_bar: ProgressBar

func update_move_amount(move_amount: float, max_value: float) -> void:
	progress_bar.max_value = max_value
	progress_bar.value     = move_amount
	if progress_bar.value > max_value:
		progress_bar.value = 0.0
