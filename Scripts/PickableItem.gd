extends Node3D

@onready var ui : Control = $"../..".get_node("UI")
@onready var player : = $"../..".get_node("Player")

@onready var item : Node3D = get_node("Item")

@export var pick_duration : float = 0.75

var bodies : Array[Node3D] = []


func _physics_process(_delta):
	if Input.is_action_just_pressed("interact"):
		if player in bodies:
			pick()


func pick():
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "queue_free"))
	tween.set_parallel(true)
	tween.tween_property(item, "global_position", player.global_position, pick_duration)
	tween.tween_property(item, "scale", Vector3.ZERO, pick_duration)


func _on_body_detector_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	if body not in bodies:
		bodies.append(body)
		if body == player:
			ui.display_interact_text()


func _on_body_detector_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	bodies.erase(body)
	if body == player:
		ui.hide_interact_text()
