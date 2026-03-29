extends Area2D

const Utils = preload("res://Scripts/Utils.gd")
const ExplosionVFX : Resource = preload("res://Scenes/VFX/ExplosionVFX.tscn")

export(int) var SPEED = 100
export(int) var HP = 3

var currentHP = 0

signal killed_by_player

func _ready():
	currentHP = HP
	connect_signals()

func _process(delta):
	var speed = SPEED * delta
	position.x -= speed

# on collision with bullets or player
func _on_Enemy_area_entered(area: Area2D):
	if area.is_in_group("Bullets"):
		get_hit()
	elif area.is_in_group("Player"):
		killed()
		
func get_hit():
	currentHP -= 1
	if currentHP == 0:
		emit_signal("killed_by_player")
		killed()
		
func killed():
	Utils.instantiate(self, ExplosionVFX, global_position)
	queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
	
func connect_signals():
	var root_node = get_tree().current_scene
	if root_node.is_in_group("World"):
		var _error = connect("killed_by_player", root_node, "_on_Enemy_killed_by_player")
