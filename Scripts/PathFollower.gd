extends StaticBody3D

@export var player : Node3D
@onready var body_detector : Area3D = get_node("BodyDetector")

@export var duration : float = 4.0
@export var path_follow : PathFollow3D


@export var desired_locations : Array[float] = [0.0, 1.0]
var current_location : float = 0

var bodies : Array[Node3D] = []


func _on_body_detector_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	if body not in bodies:
		bodies.append(body)
	if body != player: return
	
	var next_location : float = current_location + 1
	if next_location >= desired_locations.size():
		next_location = 0
	print(str(next_location))
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(path_follow, "progress_ratio", desired_locations[next_location], duration)
	current_location = next_location


func _on_body_detector_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	bodies.erase(body)
