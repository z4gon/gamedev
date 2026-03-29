extends Node

const Utils = preload("res://Scripts/Utils.gd")
const Enemy : Resource = preload("res://Scenes/Actors/Enemy.tscn")

# the spawn points
export(Array, NodePath) var spawn_points_node_paths = [] 
onready var spawn_points: Array = Utils.load_nodes(self, spawn_points_node_paths)

var rng = RandomNumberGenerator.new()

func get_spawn_position() -> Vector2:
	var idx = rng.randi_range(0, spawn_points.size() - 1)
	var point = spawn_points[idx]
	return 	point.global_position

func spawn_enemy():
	Utils.instantiate(self, Enemy, get_spawn_position())
	
func _on_Timer_timeout():
	spawn_enemy()
