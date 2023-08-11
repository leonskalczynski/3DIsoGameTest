extends Path3D

@onready var ui : Control = $"../..".get_node("UI")
@onready var player : Node3D = $"../..".get_node("Player")
@onready var path_follow : PathFollow3D = get_node("PathFollow3D")
@onready var moving_block : Node3D = path_follow.get_node("MovingBlock")
@onready var body_detector : Area3D = moving_block.get_node("BodyDetector")

@export var duration : float = 4.0

@export var desired_locations : Array[float] = [0.0, 1.0]
var current_location : float = 0

var bodies : Array[Node3D] = []


func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		if player in bodies:
			follow_path()


func follow_path():
	var next_location : float = current_location + 1
	if next_location >= desired_locations.size():
		next_location = 0
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(path_follow, "progress_ratio", desired_locations[next_location], duration)
	current_location = next_location



func _on_body_detector_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body not in bodies:
		bodies.append(body)
		if body == player:
			ui.display_interact_text()


func _on_body_detector_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	bodies.erase(body)
	if body == player:
		ui.hide_interact_text()
