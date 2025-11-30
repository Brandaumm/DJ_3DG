extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ATTACK_RANGE = 2

var player = null
var state_machine
var can_attack = true
var attack_cooldown = 0.2
var can_move = false  
var health = 6

@export var player_paths := [
	"/root/World/Player",
	"/root/World/PlayerWithoutGuns"
]

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	_find_player()
	state_machine = anim_tree.get('parameters/playback')
	_start_spawn_delay()
	add_to_group("enemy")

func _find_player():
	for p in player_paths:
		if get_tree().get_root().has_node(p):
			player = get_tree().get_root().get_node(p)
			break

	if player == null:
		push_error("Nenhum player encontrado!")

func _start_spawn_delay():
	can_move = false
	await get_tree().create_timer(6.0).timeout
	can_move = true

func _process(delta):
	if player == null:
		return  # evita crash

	velocity = Vector3.ZERO
	
	if !can_move:
		move_and_slide()
		return
	
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	var target = player.global_position
	target.y = global_position.y
	look_at(target, Vector3.UP)
	
	anim_tree.set('parameters/conditions/Zombie_Attack', _target_in_range())
	anim_tree.set('parameters/conditions/run', !_target_in_range())
	
	anim_tree.get('parameters/playback')
	
	move_and_slide()
	
func _target_in_range():
	if player == null:
		return false

	if global_position.distance_to(player.global_position) < ATTACK_RANGE and can_attack:
		can_attack = false
		attack_cooldown_timer()
		return true
	return false

func _hit_finished():
	if player == null:
		return

	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1:
		var dir = global_transform.origin.direction_to(player.global_transform.origin)
		player.hit(dir)
		
func attack_cooldown_timer():
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true

func _on_collision_shape_3d_body_part_hit(dam: Variant) -> void:
	health -= dam
	if health <= 0:
		queue_free()
		
func apply_damage(amount: int):
	health -= amount

	if health <= 0:
		die()
		
		
func die():
	can_move = false
	can_attack = false

	anim_tree.set("parameters/conditions/dying", true)

	await get_tree().create_timer(2.2).timeout

	queue_free()
