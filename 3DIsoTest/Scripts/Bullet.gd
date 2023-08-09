extends RigidBody3D

func _physics_process(delta):
	var colliding_bodies : Array[Node3D] = get_colliding_bodies()
	if colliding_bodies.size() > 0:
		queue_free()
