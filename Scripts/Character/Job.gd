## Stores a collection of data related to a class that a character can be.
class_name Job extends Resource

@export_category("Base Info")
@export           var localization_name:        String = "New Job"
@export_multiline var localization_description: String = "New description."

## The equipment a player character will start with when this is their primary class.
@export var starting_equipment: Array[ItemData] = []

## The skills associated with this class.
@export var skills: Array[SkillData] = []

@export_category("Growth Data")
@export var starting_vitality:  int = 5
@export var starting_technique: int = 5
@export var starting_will:      int = 5

@export var vitality_growth:    int = 5
@export var technique_growth:   int = 5
@export var will_growth:        int = 5
