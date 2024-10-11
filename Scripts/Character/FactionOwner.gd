## Component that descibes the owner of a character.
class_name FactionOwner extends Node

enum Factions
{
	Player,
	Enemy
}

@export var faction: Factions

func is_player_owned() -> bool:
	return faction == Factions.Player
