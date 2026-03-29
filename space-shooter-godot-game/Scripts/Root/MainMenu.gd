extends Node

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var _error = get_tree().change_scene("res://Scenes/Root/World.tscn")
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
