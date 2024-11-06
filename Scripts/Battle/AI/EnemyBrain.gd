## Defines how an enemy works.
class_name EnemyBrain extends Node

## Defines what a particular enemy can do. These are the actions it can take.
@export var behaviors: Array[UtilityAIBehavior] = []
