extends CharacterBody3D

var player  = null

@export var player_path : NodePath

const SPEED = 7.0
const ATTACK_RANGE =  10

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree
func _ready():
	player = get_node(player_path)
	
func _process(delta):
	velocity =  Vector3.ZERO
	nav_agent.set_target_position(player.global_transform.origin)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
	
	look_at(Vector3(player.global_position.x , global_position.y, player.global_position.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	anim_tree.get("parameters/playback")
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE

func _hit_finished():
	player.hit()
