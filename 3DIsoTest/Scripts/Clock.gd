extends Node

@onready var timer_group = get_parent().get_node("Timers")

func wait(time : float, object : Node, method : String, args : Array) -> int:
	if time <= 0.0:
		object.callv(method, args)
		return 555
		
	var timer = Timer.new()
	timer_group.add_child(timer)
	
	timer.one_shot = true
	timer.paused = false
	timer.autostart = false
	timer.wait_time = time
	
	if method != "":
		var callback_callable : Callable = Callable(self, "on_waiting_timer_timeout").bindv([timer, object, method, args])
		#callback_callable.bindv([timer, object, method, args])
		timer.connect("timeout", callback_callable)
	
	timer.start()
	return timer.get_instance_id()


func on_waiting_timer_timeout(timer : Node, object : Node, method : String, args : Array) -> void:
	object.callv(method, args)
	timer.queue_free()
