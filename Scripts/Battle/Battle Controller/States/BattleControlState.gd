## Base class for a state that controls a battle at a given time.
class_name BattleControlState extends State

var active_participant: Unit:
	get: return my_state_machine.active_participant
	set(value):
		my_state_machine.active_participant = value
		if active_participant != null:
			# Tell everything that needs to know about the unit being changed
			Eventbus.new_active_participant.emit(active_participant)
			
			camera_controller.set_target(active_participant)
			active_participant.finished_turn.connect( _on_turn_finished )
			if active_participant.faction_owner.is_player_owned() == true:
				my_state_machine.change_to_state("BCPlayer")
			else:
				my_state_machine.change_to_state("BCCPU")

var camera_controller: CameraController:
	get: return my_state_machine.camera_controller

func get_participants() -> Array[Unit]:
	return my_state_machine.get_participants()

func get_turn_queue() -> Array[Unit]:
	return my_state_machine.get_turn_queue()
	
func sort_on_speed() -> void:
	pass

## Triggered when a character has finished their turn.
func _on_turn_finished(u: Unit) -> void:
	active_participant.finished_turn.disconnect( _on_turn_finished )
	
	if get_turn_queue().size() > 0:
		active_participant = get_turn_queue().pop_front()
