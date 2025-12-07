extends Node3D


@onready var anim: AnimationPlayer = $"template-floor-layer2/AnimationPlayer"
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func activate():
	anim.play("up")
