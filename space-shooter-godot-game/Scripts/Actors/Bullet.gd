extends Area2D

const Utils = preload("res://Scripts/Utils.gd")
const HitVFX : Resource = preload("res://Scenes/VFX/HitVFX.tscn")

onready var shoot_sound = $ShootSound

export(int) var SPEED = 300

func _ready():
	shoot_sound.play()
	
func _process(delta):
	var speed = SPEED * delta
	position.x += speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# on collision with enemies
func _on_Bullet_area_entered(_enemy: Area2D):
	Utils.instantiate(self, HitVFX, global_position)
	queue_free()
