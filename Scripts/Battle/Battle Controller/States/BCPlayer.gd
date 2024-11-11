## The state where the active character is controlled by the player.
class_name BCPlayer extends BattleControlState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BCPlayer :: The active unit is controlled by the player.")

func check_for_unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("end_turn"):
		active_participant.finished_turn.emit( active_participant )
