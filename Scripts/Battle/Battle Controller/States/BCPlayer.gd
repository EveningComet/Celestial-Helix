## The state where the active character is controlled by the player.
class_name BCPlayer extends BattleControlState

func enter(msgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BCPlayer :: The active unit is controlled by the player.")
