extends Node2D

const PIXEL : int = 60
var tween : Tween
var moving : bool = false
var current_idle = "idle"
@onready var valid_position = position
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_derecha : RayCast2D = $RayCasts/derecha
@onready var ray_izquierda : RayCast2D = $RayCasts/izquierda

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "ui_down")
	var water = Input.is_action_just_pressed("water")
			
	if direction && not moving:
		
		move_me(direction)
	if water:
		current_idle = "water"
		animation.play(current_idle)
	
	current_idle = "idle"
	
		
func move_me(direction):
	
	var next_position : Vector2
	
	if direction.x < 0 && !ray_izquierda.is_colliding():
		next_position = position + Vector2(-PIXEL, 0)
		move_by_tween(next_position)
	elif direction.x > 0 && !ray_derecha.is_colliding():
		next_position = position + Vector2(PIXEL, 0)
		move_by_tween(next_position)

func move_by_tween(next_position: Vector2):
	moving = true
	valid_position = next_position
	tween = create_tween()
	tween.tween_property(self, "position", next_position, 0.2)
	tween.tween_callback(end_of_tween)
	
func end_of_tween():
	moving = false

