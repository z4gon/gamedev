extends Node

onready var highscore_label = $Highscore

func _ready():
	var data = SaveSystem.load_data_from_file()
	highscore_label.text = "Highscore: %s" % data.highscore

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var _error = get_tree().change_scene("res://Scenes/Root/MainMenu.tscn")
