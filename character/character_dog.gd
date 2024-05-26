extends Node2D

const PIXEL : int = 60
var tween : Tween
var moving : bool = false
var current_idle = "idle"
@onready var valid_position = position
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			
	if direction && not moving:
		moving = true
		move_me(direction)
	if !direction && !moving:
		animation.play(current_idle)

func move_me(direction):
	
	var next_position : Vector2
	
	if direction.x < 0:
		next_position = position + Vector2(-PIXEL, 0)
		animation.play("walk_left")
		current_idle = "idle"
		move_by_tween(next_position)
	elif direction.x > 0:
		next_position = position + Vector2(PIXEL, 0)
		animation.play("walk_right")
		current_idle = "idle"
		move_by_tween(next_position)

func move_by_tween(next_position: Vector2):
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.2)
	tween.tween_callback(end_of_tween)
	
func end_of_tween():
	moving = false
	animation.play("idle_down")
