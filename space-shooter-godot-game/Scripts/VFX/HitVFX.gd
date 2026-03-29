extends Node2D

onready var particles : Particles2D = $Particles2D

func _ready():
	particles.emitting = true

func _on_Timer_timeout():
	queue_free()
