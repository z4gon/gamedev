extends Area2D

export(int) var SPEED = 100

const Utils = preload("res://Scripts/Utils.gd")
const ExplosionVFX : Resource = preload("res://Scenes/VFX/ExplosionVFX.tscn")
const Bullet : Resource = preload("res://Scenes/Actors/Bullet.tscn")

signal player_died

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	process_shooting()

func process_movement(delta):
	var speed = SPEED * delta
	
	if Input.is_action_pressed("ui_up"):
		position.y -= speed
	if Input.is_action_pressed("ui_down"):
		position.y += speed

func process_shooting():
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

# FIXME: This is not ideal, an object pool should be used instead.
func shoot():
	var position = global_position
	position.x += 10
	Utils.instantiate(self, Bullet, position)

# on collision with enemies
func _on_Ship_area_entered(_enemy: Area2D):
	emit_signal("player_died")
	queue_free()

func _exit_tree():
	Utils.instantiate(self, ExplosionVFX, global_position)
