class_name AIExecuteAction extends AIState

func enter(msgs: Dictionary = {}) -> void:
	pass

func physics_update(delta: float) -> void:
	await my_state_machine.get_tree().create_timer(1.0, false, false).timeout
	_unit.finished_turn.emit(_unit)
	my_state_machine.change_to_state("AIWaiting")

func _determine_resolution() -> void:
	pass
