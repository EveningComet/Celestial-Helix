## Manages the battle hud for the player.
class_name BattleHUD extends CanvasLayer

@export var unit_move_amount_displayer: UnitMoveAmountDisplayer
@export var action_points_displayer_container: Container
@export var action_points_value_displayer:     Label

@export var skill_hotbar: SkillHotbar

## The unit currently being kept track of.
var active_participant: Unit = null

func _ready() -> void:
	# This HUD should recognize when the active character is being changed.
	Eventbus.new_active_participant.connect( _on_new_active_participant )
	set_physics_process( false )

func _physics_process(delta: float) -> void:
	unit_move_amount_displayer.update_move_amount(
		active_participant.curr_move_amount,
		active_participant.meters_per_ap
	)
	
func _on_new_active_participant(unit: Unit) -> void:
	if active_participant != null:
		active_participant.ap_changed.disconnect( _on_ap_changed )
	active_participant = unit
	
	if unit.faction_owner.is_player_owned() == true:
		active_participant.ap_changed.connect( _on_ap_changed )
		action_points_value_displayer.set_text( str(active_participant.curr_action_points) )
		skill_hotbar.update_unit(active_participant)
		show()
		set_physics_process( true )
	else:
		hide()
		set_physics_process( false )

func _on_ap_changed(unit: Unit) -> void:
	action_points_value_displayer.set_text( str(active_participant.curr_action_points) )
