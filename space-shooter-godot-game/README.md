# Space Shooter Game
Godot 3.5.x

A basic game made in Godot, following the course: https://heartbeast-gamedev-school.teachable.com/p/1-bit-godot-course

## Table of Contents
- [Space Shooter Game](#space-shooter-game)
	- [Table of Contents](#table-of-contents)
	- [Screenshots](#screenshots)
	- [Project Setup](#project-setup)
	- [Nodes Used](#nodes-used)
	- [Scenes](#scenes)
	- [Shoot Bullets: Instancing](#shoot-bullets-instancing)
	- [Collisions](#collisions)
		- [Layers](#layers)
		- [Masks](#masks)
		- [Signals](#signals)
	- [Visibility Notifiers](#visibility-notifiers)
	- [Enemy Spawner: Instancing](#enemy-spawner-instancing)
		- [Spawn Points](#spawn-points)
		- [Randomizer](#randomizer)
		- [Spawn the Enemy](#spawn-the-enemy)
	- [Explosion](#explosion)
		- [Ship and Enemies](#ship-and-enemies)
	- [Score](#score)
		- [Custom Signal](#custom-signal)
		- [Setters \& Getters](#setters--getters)
	- [Stars Particles](#stars-particles)
	- [Audio](#audio)
	- [Hit VFX](#hit-vfx)
	- [Font](#font)
	- [Changing Scenes](#changing-scenes)
	- [Autoload Singletons](#autoload-singletons)
	- [Timers \& Yield](#timers--yield)
	- [Save System](#save-system)
  
## Screenshots

https://user-images.githubusercontent.com/4588601/218189204-54db414a-3263-47b0-a694-67dd96a9e450.mov

![Picture](./docs/1.jpg)
![Picture](./docs/2.jpg)
![Picture](./docs/3.jpg)

## Project Setup

- Set Window Height/Width, Test Height/Width and Stretch Mode to 2D.
- Turn on Smart Snapping to 16px and show the Grid.

## Nodes Used

- Node
  - Node2D
    - Area2D
    - Sprite
    - ColliderPolygon2D
    - RigidBody2D
    - VisibilityNotifier2D
    - Position2D
    - Particles2D
  - Label
  - Timer
  - AudioStreamPlayer

## Scenes

- World
- Ship
- Enemy

## Shoot Bullets: Instancing

- Get a reference to a `Scene`

```py
var Bullet : Resource = preload("res://Scenes/Bullet.tscn")
```

- Instantiate the resource.
- Add it to the root node of the scene.
- Set its position.
  
```py
const Utils = preload("res://Scripts/Utils.gd")

# FIXME: This is not ideal, an object pool should be used instead.
func shoot():
	var position = global_position
	position.x += 10
	Utils.instantiate(self, Bullet, position)
```

```py
# Scripts/Utils.gd

static func instantiate(context: Node, resource: Resource, position: Vector2):
	var instance = resource.instance()						# instantiate the scene
	var root_node = context.get_tree().current_scene 		# get the root node of the main scene
	root_node.add_child(instance)							# add to the root node
	instance.global_position = position						# position in the same place as the ship
```

## Collisions

### Layers

- Name the Physics 2D layers.
- Set `Ship` to be in the Ship `Layer`
- Set `Bullet` to be in the Bullets `Layer`
- Set `Enemy` to be in the Enemies `Layer`

### Masks

- `Mask` the collisions of the `Ship` to only interact with `Enemies`
- `Mask` the collisions of the `Enemies` to only interact with `Bullets`
  
### Signals

- Use signal `area_entered` to detect collision between the Ship and Enemies.
- We could use `RigidBody2D` but we won't because:
  - It's impossible to detect when areas run into the rigid body, we'd need to use rigid bodies for all actos.
  - This is so simple that we don't need the overhead of physics calculations.

```py
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
```

```py
# on collision with enemies
func _on_Bullet_area_entered(enemy: Area2D):
	Utils.instantiate(self, HitVFX, global_position)
	queue_free()
```

```py
# on collision with enemies
func _on_Ship_area_entered(enemy: Area2D):
	queue_free()
```

## Visibility Notifiers

- Add `VisibiliyNotifier2D` nodes to the Enemies and Bullets.
- Connect the signal `screen_exited` to a function that executes `queue_free()`

```py
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
```

## Enemy Spawner: Instancing

### Spawn Points

- Export an `Array` of `NodePath` to have references to different spawn points as needed.
- Then use a custom function to load these nodes to be able to access their position.

```py
const Utils = preload("res://Scripts/Utils.gd")

export(Array, NodePath) var spawn_points_node_paths = [] 
onready var spawn_points: Array = Utils.load_nodes(self, spawn_points_node_paths)
```

```py
# Scripts/Utils.gd

static func load_nodes(context: Node, node_paths: Array) -> Array:
	var nodes = []
	for node_path in node_paths:
		var node = context.get_node(node_path)
		if node != null:
			nodes.append(node)
	return nodes
```

### Randomizer

- Use a pseudo random number generator to pick a random spawn point.
- Return the position to use when positioning the newly spawned enemy.

```py
const Enemy : Resource = preload("res://Scenes/Enemy.tscn")

var rng = RandomNumberGenerator.new()
```

```py
func get_spawn_position() -> Vector2:
	var idx = rng.randi_range(0, spawn_points.size() - 1)
	var point = spawn_points[idx]
	return 	point.global_position
```

### Spawn the Enemy

- Use a `Timer` Node and connect the `timeout()` signal to the Enemy Spawner.

```py
func _on_Timer_timeout():
	spawn_enemy()
```

```py
func spawn_enemy():
	Utils.instantiate(self, Enemy, get_spawn_position())
```

## Explosion

- Using a `Sprite` and an `AnimationPlayer` define a new scene for the `Explosion`
- In the animation, add a `Call Method Track` to call `queue_free()` when the animation ends.
- Make the animation autoplay when the node enters the tree.

### Ship and Enemies

- When enemies and the ship die, we need to show the explosion.

```py
var ExplosionVFX : Resource = preload("res://Scenes/ExplosionVFX.tscn")

func _exit_tree():
	Utils.instantiate(self, ExplosionVFX, global_position)
```

## Score

- Add a `Label` node to the world scene.

### Custom Signal

- Make the `Enemy` fire a custom signal whenever it is killed by the player.
- Make the `World` scene's root node to be in the `Group` called "World".
- Connect the signal of the enemy to the root node dynamically on ready.

```py
signal killed_by_player

func _ready():
	connect_signals()

func connect_signals():
	var root_node = get_tree().current_scene
	if root_node.is_in_group("World"):
		connect("killed_by_player", root_node, "_on_Enemy_killed_by_player")
```

### Setters & Getters

- Define a `setter` in `World` that updates the score and the label.

```py
onready var score_label: Label = $ScoreLabel

var score = 0 setget set_score

func _on_Enemy_killed_by_player():
	self.score += 10

func set_score(value):
	score = value
	score_label.text = "Score = %s" % score
```

## Stars Particles

- Using Godot's Particle System, define a `Particles2D` node in the World scene.
- Add a sub resource `Particles Material`
- Set the properties:
  - Lifetime = 7
  - Amount = 200
  - Preprocess = 7 (to fill the screen with stars on start)
  - Emission Type = Box
    - Box Extents y = 90 (whole window height)
  - Gravity = 0
  - Velocity = -100
    - Velocity Random = 0.5
  - Direction x = 1
    - Spread = 0

## Audio

- Use an `AudioStreamPlayer` with `autoplay`.
- Or get a reference to the audio stream player like this `onready var shoot_sound = $ShootSound` and then play it `shoot_sound.play()`

## Hit VFX

- Use an `Particles2D` node as `one_shot`, configure the properties of the particles to generate a mini explosion.
- Add a `hit` sound.

```py
# on collision with enemies
func _on_Bullet_area_entered(enemy: Area2D):
	Utils.instantiate(self, HitVFX, global_position)
	queue_free()
```

## Font

- Create a `DynamicFont` `Resource` and make it use the `.ttf` font we imported.
- In the `Label`, set the font to our new resource and adjust the size.

## Changing Scenes

- Navigate to a new scene with `get_tree().change_scene("res://Scenes/World.tscn")`
- 
## Autoload Singletons

- Persisting elements across scenes changing, use `Project Settings > AutoLoad` and load the `Music.tsc` which will play the music across scenes.

## Timers & Yield

- Create timers on the fly by doing:

```py
func _on_Ship_player_died():
	var timer = get_tree().create_timer(1) # after 1 sec
	yield(timer, "timeout")
	get_tree().change_scene("res://Scenes/Root/GameOverMenu.tscn")
```

## Save System

- Create an `autoload` `Singleton` to manage reading and writing to the save file.
- In the `World` scene, react to the player dying and update the highscore.
- In the `GameOver` scene, show the highscore.
- Use the `user://` folder to save to the platform specific folder for user data.

```py
var SAVE_DATA_PATH = "user://save_data.json"

var default_save_data = {
	highscore = 0
}

func save_data_to_file(save_data):
	var file = File.new()
	
	file.open(SAVE_DATA_PATH, File.WRITE)
	file.store_line(to_json(save_data))
	file.close()

func load_data_from_file():
	var file = File.new()
	
	if file.file_exists(SAVE_DATA_PATH):
		file.open(SAVE_DATA_PATH, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		return data
	else:
		return default_save_data
```

```py
func save_highscore():
	var data = SaveSystem.load_data_from_file()
	if score > data.highscore:
		data.highscore = score
		SaveSystem.save_data_to_file(data)

func _on_Ship_player_died():
	save_highscore()
```

```py
func _ready():
	var data = SaveSystem.load_data_from_file()
	highscore_label.text = "Highscore: %s" % data.highscore
```
