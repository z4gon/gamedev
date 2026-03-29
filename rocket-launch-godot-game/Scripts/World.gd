extends Node

# onready var animationPlayer : AnimationPlayer = get_node("AnimationPlayer")
onready var animationPlayer : AnimationPlayer = $MyAnimationPlayer

func _ready():
	pass

func _on_LaunchButton_pressed():
	animationPlayer.play("Launch")
