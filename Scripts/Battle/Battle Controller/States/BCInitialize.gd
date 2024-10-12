## Sets up the battle.
class_name BCInitialize extends BattleControlState

func enter(mgs: Dictionary = {}) -> void:
	if OS.is_debug_build() == true:
		print("BCInitialize :: Entered.")
	
	_initialize_battle()

func _initialize_battle() -> void:
	# TODO: Better way of loading audio.
	var audio: AudioStream = preload("res://Imported Assets/Audio/Music/Aron Krogh/Aron Krogh - Heated Battle (Loop).mp3")
	SoundManager.play_music(
		audio, 1.0, "Music"
	)
	
	# Create the array and sort based on speed
	# TODO: Sort based on the unit's speed.
	get_turn_queue().append_array( get_participants() )
	
	# TODO: Figure out how to overcome this race condition.
	await get_tree().create_timer(0.1, false, true).timeout
	
	# Start with the fastest unit
	active_participant = get_turn_queue().pop_front()
