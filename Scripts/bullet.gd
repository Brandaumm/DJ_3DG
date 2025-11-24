extends Node3D

const SPEED = 40.0
@export var damage: int = 1

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D

func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED * delta)

	if ray.is_colliding():

		mesh.visible = false
		particles.emitting = true
		ray.enabled = false

		var hit_obj = ray.get_collider()
		print(hit_obj)

		# Se atingiu a HurtBox
		if hit_obj.is_in_group("hurtbox"):
			hit_obj.take_damage(damage)

		await get_tree().create_timer(0.7).timeout
		queue_free()
