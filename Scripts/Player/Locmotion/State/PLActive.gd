## The plyer is actively controlling a unit.
class_name PLActive extends PLState

func enter(msgs: Dictionary = {}) -> void:
	my_state_machine.active_participant.finished_turn.connect( _on_unit_turn_finished )

func exit() -> void:
	my_state_machine.active_participant.finished_turn.disconnect( _on_unit_turn_finished )

func _on_unit_turn_finished(unit: Unit) -> void:
	my_state_machine.change_to_state("PLWaiting")
