extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not body.is_in_group("player"):
		return

	var current_level := get_tree().current_scene.name
	print('esta no grupo')
	print(current_level)
	match current_level:
		"Level1":
			get_tree().change_scene_to_file("res://Levels/level_2.tscn")
		"World":
			get_tree().change_scene_to_file("res://Levels/level_3.tscn")
		_:
			print("Não há próximo level configurado para:", current_level)
