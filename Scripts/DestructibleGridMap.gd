extends GridMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func destroy_tile(collision_point):
	var map_coordinate = local_to_map(collision_point)
	set_cell_item(map_coordinate, -1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
