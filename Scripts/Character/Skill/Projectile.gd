## An object that can be fired.
class_name Projectile extends Area3D

signal projectile_despawned(p: Projectile)

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
var _damage_data: DamageData = null

var _velocity: Vector3 = Vector3.ZERO

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	set_as_top_level(true)
	
func _physics_process(delta: float) -> void:
	global_position += _velocity * speed * delta
	
	_curr_lifetime += delta
	if _curr_lifetime > max_lifetime:
		_on_destroy()

func initialize(
		direction: Vector3,
		f_owner:   FactionOwner,
		dd:        DamageData
	) -> void:
	_velocity    = direction
	_damage_data = dd
	faction_owner.copy_faction( f_owner )

func _on_body_entered(body) -> void:
	if body is Unit:
		var as_unit = body as Unit
		
		match application_type:
			ApplicationTypes.Damage:
				
				# Don't hurt allies.
				if faction_owner.faction == as_unit.faction_owner.faction:
					return
				
				# Deal the damage.
				as_unit.combatant.stats.take_damage(_damage_data)
			
			ApplicationTypes.Heal:
				# Don't heal enemies.
				if faction_owner.faction != as_unit.faction_owner.faction:
					return
				
				as_unit.combatant.stats.heal(_damage_data.damage_amount)
	if OS.is_debug_build() == true:
		print("Projectile :: %s has collided with %s." % [name, body.name])
	_on_destroy()

func _on_destroy() -> void:
	projectile_despawned.emit(self)
	queue_free()
