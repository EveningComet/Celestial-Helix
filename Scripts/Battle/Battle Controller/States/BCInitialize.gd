## Sets up the battle.
class_name BCInitialize extends BattleControlState

func enter(mgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BCInitialize :: Entered.")
