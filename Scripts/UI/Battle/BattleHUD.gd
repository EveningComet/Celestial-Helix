## Manages the battle hud for the player.
class_name BattleHUD extends CanvasLayer

@export var action_points_displayer_container: Container
@export var action_points_value_displayer:     Label

## The unit currently being kept track of.
var active_participant: Unit

func _ready() -> void:
	# This HUD should recognize when the active character is being changed.
	Eventbus.new_active_participant.connect( _on_new_active_participant )
	
func _on_new_active_participant(unit: Unit) -> void:
	active_participant = unit
	
	if unit.faction_owner.is_player_owned() == true:
		action_points_value_displayer.set_text( str(active_participant.curr_action_points) )
		action_points_displayer_container.show()
	else:
		action_points_displayer_container.hide()
