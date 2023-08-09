extends Node3D

@onready var player : Node3D = get_parent().get_node("Player")

const SMOOTHNESS = 0.07

func _ready():
	position = player.position

func _process(_delta):
	position = lerp(position, player.position, SMOOTHNESS)
