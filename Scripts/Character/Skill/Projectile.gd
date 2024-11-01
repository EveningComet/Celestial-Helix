## An object that can be fired.
class_name Projectile extends Area3D

enum ApplicationTypes
{
	Damage,
	Heal,
	Explode
}

## Many projectiles will need to know what side they're on so the shooter
## doesn't hurt allies.
@export var faction_owner: FactionOwner

@export var speed: float = 25.0
@export var max_lifetime: float = 10.0
var _curr_lifetime:       float = 0.0

@export var application_type: ApplicationTypes

## How much healing/damage to apply.
var _power: int = 5
# TODO: Element/Type.

var _velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	global_position += _velocity * speed * delta
	
	_curr_lifetime += delta
	if _curr_lifetime > max_lifetime:
		queue_free()

func initialize(direction: Vector3, f_owner: FactionOwner) -> void:
	_velocity = direction
	faction_owner.copy_faction( f_owner )

func _on_body_entered(body) -> void:
	if body is Unit:
		var as_unit = body as Unit
		
		match application_type:
			ApplicationTypes.Damage:
				
				# Don't hurt allies.
				if faction_owner.faction == as_unit.faction_owner.faction:
					return
				
				# Deal the damage
				as_unit.combatant.stats
			
			ApplicationTypes.Heal:
				# Don't heal enemies.
				if faction_owner.faction != as_unit.faction_owner.faction:
					return
				
				as_unit.combatant.stats.heal(_power)
	if OS.is_debug_build() == true:
		print("Projectile :: %s has collided with %s." % [name, body.name])
	queue_free()
