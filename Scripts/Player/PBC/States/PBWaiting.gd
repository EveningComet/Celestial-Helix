## When the player is waiting for their turn.
class_name PBWaiting extends PBState

func enter(msgs: Dictionary = {}) -> void:
	Eventbus.new_active_participant.connect( _on_new_active_participant )

func exit() -> void:
	Eventbus.new_active_participant.disconnect( _on_new_active_participant )

## When the new unit is owned by the player, switch states.
func _on_new_active_participant(new_unit: Unit) -> void:
	if new_unit.faction_owner.is_player_owned() == true:
		my_state_machine.change_to_state("States/PBActive", {"unit" = new_unit})
