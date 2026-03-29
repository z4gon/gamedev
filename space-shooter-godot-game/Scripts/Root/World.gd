extends Node

onready var score_label: Label = $ScoreLabel

var score = 0 setget set_score

func _on_Enemy_killed_by_player():
	self.score += 10

func set_score(value):
	score = value
	score_label.text = "Score = %s" % score
	
func save_highscore():
	var data = SaveSystem.load_data_from_file()
	if score > data.highscore:
		data.highscore = score
		SaveSystem.save_data_to_file(data)

func _on_Ship_player_died():
	save_highscore()
	var timer = get_tree().create_timer(1) # after 1 sec
	yield(timer, "timeout")
	var _error = get_tree().change_scene("res://Scenes/Root/GameOverMenu.tscn")
