extends PathFollow3D

@export var duration = 4.0
@export var desired_progress = 1.0
@export var complete_margin = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	#follow_path()
	pass
	

func _process(delta):
	var tween : Tween = create_tween()
	#var callback_callable : Callable = Callable(self, follow_path())
	#tween.finished.connect(callback_callable)
	
	if progress_ratio >= desired_progress - complete_margin:
		#print("Hello")
		progress_ratio = 0.0
		#tween.tween_property(self, "progress_ratio", desired_progress, duration)
	tween.tween_property(self, "progress_ratio", desired_progress, duration)
