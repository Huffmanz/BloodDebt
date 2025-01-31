extends Node2D

const PAUSE_MENU = preload("res://ui/pause_menu.tscn")

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		add_child(PAUSE_MENU.instantiate())
		get_tree().root.set_input_as_handled()
