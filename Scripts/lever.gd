extends Node3D

@onready var anim: AnimationPlayer = $lever2/AnimationPlayer
@onready var area_3d: Area3D = $lever2/Area3D
@onready var switch: AudioStreamPlayer3D = $AudioStreamPlayer3D

var player_in_area: bool = false
var is_on: bool = false

signal lever_toggled(lever_id, state)

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		_use_lever()


func _use_lever():
	if is_on:
		anim.play("toggle-off")
		is_on = false
	else:
		anim.play("toggle-on")
		is_on = true
	switch.play()

	emit_signal("lever_toggled", self.name, is_on)


func force_off():
	if is_on:
		anim.play("toggle-off")
		is_on = false


func _on_area_3d_body_entered(body: CharacterBody3D) -> void:
	if body.name == "Player" || "PlayerWithoutGuns":
		player_in_area = true


func _on_area_3d_body_exited(body: CharacterBody3D) -> void:
	if body.name == "Player" || "PlayerWithoutGuns":
		player_in_area = false
