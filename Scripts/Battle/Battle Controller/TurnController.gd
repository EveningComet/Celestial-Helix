## Keeps track of the character's currently participating in a battle.
class_name TurnController extends Node

## The current, active participants in a battle.
@export var participants: Array[Unit] = []

## Stores the characters that still need to act for the current turn.
var turn_queue: Array[Unit] = []

## The character that is currently having their turn performed.
var active_participant: Unit:
	get: return active_participant
	set(value): active_participant = value
