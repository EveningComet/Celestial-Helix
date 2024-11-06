## Stores a variety of information that will be needed to resolve actions.
class_name TargetingData extends Resource

## The character performing a particular action.
var activator: Unit

## Stores the starting position, if needed. Typically used for things such as warping,
## or shooting a projectile.
var origin: Vector3 = Vector3.ZERO

## Some skills will need to know the final destination, such as teleports. Others will need
## a direction.
var target_v: Vector3 = Vector3.ZERO

## The things that will have stuff done to them.
var targets: Array[Unit] = []
