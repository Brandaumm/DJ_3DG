extends CharacterBody3D


const WALK_SPEED = 5.0
const SPRINTING_SPEED = 8.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.004
const BASE_FOV = 75
const FOV_CHANGE = 1.5
const HIT_STAGGER = 20

const BOB_FREQ = 3.0
const BOB_AMP = 0.08

var speed
var t_bob = 0.0
var base_cam_pos := Vector3.ZERO

@export var player_path := "Player"

var bullet = load("res://Assets/3D_Models/Gun/bullet.tscn")
var instance

@onready var head = $Head
@onready var camera = $Head/Camera3D
@onready var gun_anim = $Head/Camera3D/Rifle/AnimationPlayer
@onready var gun_barrel = $Head/Camera3D/Rifle/RayCast3D


signal player_hit


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	base_cam_pos = camera.transform.origin

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x , deg_to_rad(-90), deg_to_rad(90))
		
func _physics_process(delta: float) -> void:	
	
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
		
	if Input.is_action_pressed("sprint"):
		speed = SPRINTING_SPEED 
	else:
		speed = WALK_SPEED
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction: Vector3 = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
	
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0)
	
	t_bob += delta * velocity.length() * float(is_on_floor())
	var bob_offset: Vector3 = _headbob(t_bob)	
	
	var cam_transform = camera.transform
	cam_transform.origin = base_cam_pos + bob_offset
	camera.transform = cam_transform
	
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINTING_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 0.0)
	
	if Input.is_action_pressed("shoot"):
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
	
	move_and_slide()
	
func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ /2) * BOB_AMP
	return pos
	
func hit(dir):
	print("hit")
	emit_signal("player_hit")
	velocity += dir * HIT_STAGGER
