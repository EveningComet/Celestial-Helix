## State for where it's the enemy's turn.
class_name BCCPU extends BattleControlState

func enter(msgs: Dictionary = {}) -> void:
	await get_tree().create_timer(1.0, false, true).timeout
	active_participant.finished_turn.emit( active_participant )
