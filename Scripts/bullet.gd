extends Node3D

const SPEED = 40.0
@export var damage: int = 1

@onready var mesh = $MeshInstance3D
@onready var ray = $RayCast3D
@onready var particles = $GPUParticles3D
@onready var hit_flesh: AudioStreamPlayer3D = $hit_flesh

func _process(delta):
	position += transform.basis * Vector3(0, 0, -SPEED * delta)

	if ray.is_colliding():

		if ray.get_collider().has_method("destroy_tile"):
			ray.get_collider().destroy_tile(ray.get_collision_point() -  ray.get_collision_normal())
		mesh.visible = false
		particles.emitting = true
		ray.enabled = false

		var hit_obj = ray.get_collider()
		print(hit_obj)

		if hit_obj.is_in_group("hurtbox"):
			hit_obj.take_damage(damage)
			hit_flesh.play()
			
	

		await get_tree().create_timer(0.7).timeout
		queue_free()
