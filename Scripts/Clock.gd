extends Node

@onready var timer_group = get_parent().get_node("Timers")

var time : float = 0.0
var object = null
var method : String = ""
var args : Array = []


func repeat(_time : float, _object : Node, _method : String, _args : Array):
	var timer = Timer.new()
	timer_group.add_child(timer)
	timer.wait_time = _time  # Use the passed _time instead of the class variable time
	timer.one_shot = false
	timer.paused = false
	timer.autostart = false
	
	# Connect the signal with the required arguments
	var timeout_callable : Callable = Callable(self, "on_repeating_timer_timeout").bindv([timer, _object, _method, _args])
	timer.connect("timeout", timeout_callable)
	
	timer.start()


func on_repeating_timer_timeout(_timer : Node, _object : Node, _method : String, _args : Array):
	_object.callv(_method, _args)
