extends Area3D

@export var owner_path: NodePath   # Referência ao Zombie

var zombie_owner

func _ready():
	zombie_owner = get_node(owner_path)
	add_to_group("hurtbox")

func take_damage(dmg: int):
	if zombie_owner and zombie_owner.has_method("apply_damage"):
		zombie_owner.apply_damage(dmg)
