extends Node2D

const PIXEL : int = 60
var tween : Tween
var moving : bool = false
var attacking : bool = false  # Añadir variable para controlar el estado de ataque
var current_idle = "idle"
@onready var valid_position = position
@onready var animation : AnimatedSprite2D = $AnimatedSprite2D

var energia: float = 100.0  # Inicializar energía al 100%
var last_direction: Vector2 = Vector2.ZERO

signal perro_se_movio(energia)
signal perro_inactivo()
signal wuau()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "ui_down")
	var action = Input.is_action_pressed("water")

	if action and !attacking:  # Si la acción de ataque se detecta y no está atacando
		attacking = true
		if direction.x < 0:
			animation.play("attack_izquierda")
			emit_signal("wuau")
		elif direction.x > 0:
			animation.play("attack_derecha")
			emit_signal("wuau")
		else:
			animation.play("attack_derecha")  # Ajustar según la dirección por defecto si no hay dirección
			emit_signal("wuau")

	if attacking:
		if not animation.is_playing():
			attacking = false  # Restablecer el estado de ataque una vez que la animación haya terminado
			print("Attack animation finished")  # Debug

	if direction and !moving and !attacking:  # Mover solo si no está atacando
		moving = true
		move_me(direction)
		energia -= 150.0 * delta
		emit_signal("perro_se_movio", energia)
	if !direction and !moving and !attacking:  # Solo reproducir animación idle si no está atacando
		animation.play(current_idle)
		emit_signal("perro_inactivo")
		energia += 0.5 * delta
		energia = max(0, energia)

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

