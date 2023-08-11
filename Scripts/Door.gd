extends Node3D

@onready var ui : Control = $"../..".get_node("UI")
@onready var turning_point : StaticBody3D = get_node("TurningPoint")
@onready var player : = $"../..".get_node("Player")
#@onready var body_detector : Area3D = get_node("BodyDetector")

@export var duration : float = 1.25

@export var desired_rotations : Array[float] = [0.0, 90.0]

var current_rotation : float = 0

var bodies : Array[Node3D] = []


func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		if player in bodies:
			turn_door()


func turn_door():
	var next_rotation : float = current_rotation + 1
	if next_rotation >= desired_rotations.size():
		next_rotation = 0
	
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(turning_point, "rotation_degrees:y", desired_rotations[next_rotation], duration)
	current_rotation = next_rotation


func _on_body_detector_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body not in bodies:
		bodies.append(body)
		if body == player:
			ui.display_interact_text()


func _on_body_detector_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	bodies.erase(body)
	if body == player:
		ui.hide_interact_text()
