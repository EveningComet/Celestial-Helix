## Used to fire events that would be very tedious to pass otherwise.
extends Node

## Fired whenever the active participant has changed.
signal new_active_participant(unit: Unit)
