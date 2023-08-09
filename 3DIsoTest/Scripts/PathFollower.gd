extends PathFollow3D

@export var duration = 4.0
@export var end_acceptance = 0.1

var desired_progress : float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	#follow_path()
	pass
	

func _physics_process(delta):
	var tween : Tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.set_ease(Tween.EASE_IN)
	
	#print(str(progress_ratio))
	var progress_margin = desired_progress - end_acceptance if desired_progress == 1 else end_acceptance
	if progress_ratio < progress_margin:
		desired_progress = 1.0
	else:
		desired_progress = 0.0
		
	tween.tween_property(self, "progress_ratio", desired_progress, duration)
