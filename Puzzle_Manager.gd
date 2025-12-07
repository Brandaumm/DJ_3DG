extends Node3D

var correct_levers = ["Lever2", "Lever3", "Lever5"]  # ajuste conforme o nome das alavancas
var activated = []
@onready var elevator: Node3D = $Elevator

func _ready():
	for lever in get_children():
		if lever.has_signal("lever_toggled"):
			lever.lever_toggled.connect(_on_lever_toggled)


func _on_lever_toggled(lever_id, state):
	if not state:
		return

	if lever_id in correct_levers:
		if lever_id not in activated:
			activated.append(lever_id)

		if activated.size() == correct_levers.size():
			activate_bridge()
	else:
		reset_puzzle()


func reset_puzzle():
	activated.clear()

	for lever in get_children():
		if lever.has_method("force_off"):
			lever.force_off()


func activate_bridge():
	elevator.activate()
