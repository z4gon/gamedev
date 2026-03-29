extends Area2D

export (int) var PIG_SPEED = 100
var is_moving = false
var is_moving_left = false
onready var anim_player = $AnimationPlayer
onready var sprite = $Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	process_movement(delta)
	flip()
	animate()

func process_movement(delta):
	var speed = PIG_SPEED * delta
	
	is_moving = false
	
	if Input.is_action_pressed("ui_right"):
		move(speed, 0)
	if Input.is_action_pressed("ui_left"):
		move(-speed, 0)
	if Input.is_action_pressed("ui_up"):
		move(0, -speed)
	if Input.is_action_pressed("ui_down"):
		move(0, speed)

func move(dx: float, dy: float):
	is_moving = true
	is_moving_left = dx < 0 or (is_moving_left and dx == 0) # keep facing left if no change is needed
	
	position.x += dx
	position.y += dy
	
func flip():
	sprite.flip_h = is_moving_left	

func animate():
	if is_moving:
		anim_player.play("Run")
	else:
		anim_player.play("Idle")

# equivalent to:
#
# var areas = get_overlapping_areas()
# for area in areas:
#	 area.queue_free()
func _on_Pig_area_entered(area: Area2D):
	eat_apple(area)
	
func eat_apple(apple: Area2D):
	apple.queue_free() # destroy the node
	scale *= 1.1
	
