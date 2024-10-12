## Manages the battle hud for the player.
class_name BattleHUD extends CanvasLayer

@export var action_points_displayer_container: Container

func _ready() -> void:
	# This HUD should recognize when the active character is being changed.
	Eventbus.new_active_participant.connect( _on_new_active_participant )
	
func _on_new_active_participant(unit: Unit) -> void:
	print("BattleHUD :: Active participant changed.")
	
	if unit.faction_owner.is_player_owned() == true:
		action_points_displayer_container.show()
	else:
		action_points_displayer_container.hide()
