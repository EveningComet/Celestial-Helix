## Waiting for the game to get to an active, controllable unit.
class_name PLWaiting extends PLState

func enter(msgs: Dictionary = {}) -> void:
	Eventbus.new_active_participant.connect( _on_new_active_participant )

func exit() -> void:
	Eventbus.new_active_participant.disconnect( _on_new_active_participant )

func _on_new_active_participant(new_unit: Unit) -> void:
	if new_unit.faction_owner.is_player_owned() == true:
		my_state_machine.active_participant = new_unit
		my_state_machine.change_to_state("PLActive", {new_unit = new_unit})
