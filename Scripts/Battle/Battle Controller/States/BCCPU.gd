## State for where it's the enemy's turn.
class_name BCCPU extends BattleControlState

func enter(msgs: Dictionary = {}) -> void:
	_perform_turn()

## Have the enemy do its turn.
func _perform_turn() -> void:
	var enemy_brain: EnemyBrain = active_participant.get_node("EnemyBrain")
	enemy_brain.do_turn(get_participants())
