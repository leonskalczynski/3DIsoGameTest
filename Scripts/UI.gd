extends Control

@onready var hint_text : Label = get_node("HintText")


func display_interact_text():
	hint_text.text = "Press E to interact"
	hint_text.show()

func hide_interact_text():
	hint_text.hide()
