## State for where a battle has ended.
class_name BCEnd extends BattleControlState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BCEnd :: Entered.")
