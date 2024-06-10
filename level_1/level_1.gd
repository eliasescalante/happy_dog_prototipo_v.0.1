extends Node2D

# Declara las variables para las barras de energía y aburrimiento
var barra_energia: ProgressBar
var barra_aburrimiento: ProgressBar
var barra_agua: ProgressBar
var character_dog_node
var puntaje: int = 0  # Variable para el puntaje
var tiempo_sin_movimiento: float = 0.0
const TIEMPO_SIN_MOVIMIENTO_MAXIMO: float = 5.0  # Tiempo máximo sin movimiento antes de que la barra de aburrimiento comience a llenarse
const AGUA_DECREMENTO: float = 10.0  # Valor que se decrementa de la barra de agua cada vez que se presiona la barra espaciadora
const ENERGIA_DECREMENTO_RAPIDO: float = 10.0  # Valor que se decrementa de la barra de energía al moverse
const ENERGIA_INCREMENTO: float = 1.0  # Valor que se incrementa de la barra de energía al estar inactivo

var juego_en_curso: bool = true  # Bandera para indicar si el juego está en curso

@onready var audio_player = $AudioStreamPlayer2D
@onready var character_dog = $character_dog
var aburrimiento_anterior: float = 0.0  # Variable para almacenar el valor anterior de la barra de aburrimiento

func _ready():
	# Asegúrate de que las barras estén correctamente asignadas en el editor de Godot
	# y que tengan los nombres correctos
	barra_energia = $BarraEnergia
	barra_aburrimiento = $BarraAburrimiento
	barra_agua = $BarraAgua
	
	# Inicializar la barra de energía al 100%
	barra_energia.value = 100
	aburrimiento_anterior = barra_aburrimiento.value  # Inicializar el valor anterior de aburrimiento
	
	# Reproduce el audio al iniciar el juego
	audio_player.play()
	
	# Conecta las señales del perro a las funciones correspondientes en este script
	character_dog.connect("perro_se_movio", self._on_perro_se_movio)
	character_dog.connect("perro_inactivo", self._on_perro_inactivo)
	character_dog.connect("wuau", self._on_perro_ladro)

# Función para actualizar la barra de energía cuando el perro se mueve
func _on_perro_se_movio(energia: float):
	if juego_en_curso:
		barra_energia.value = min(100, max(0, barra_energia.value - ENERGIA_DECREMENTO_RAPIDO))
		tiempo_sin_movimiento = 0.0
		
		_decrementar_aburrimiento()
		
		# Verificar si la barra de energía llegó al mínimo (perro cansado)
		if barra_energia.value <= 1:
			_fin_del_juego("El perro está cansado. ¡Perdiste!")

# Función para manejar el incremento del aburrimiento y energía cuando el perro está inactivo
func _on_perro_inactivo():
	if juego_en_curso:
		tiempo_sin_movimiento += 1
		_decrementar_aburrimiento()
		
		# Recuperar energía cuando el perro está inactivo
		if barra_energia.value < 100:
			barra_energia.value = min(100, barra_energia.value + ENERGIA_INCREMENTO)
		
		# Actualizar la barra de aburrimiento si el perro no se ha movido durante un tiempo
		if tiempo_sin_movimiento >= TIEMPO_SIN_MOVIMIENTO_MAXIMO:
			barra_aburrimiento.value += 1
		
		# Verificar si la barra de aburrimiento llegó al máximo (perro aburrido)
		if barra_aburrimiento.value >= 98:
			_fin_del_juego("El perro está aburrido. ¡Perdiste!")

# Función para finalizar el juego con un mensaje
func _fin_del_juego(mensaje: String):
	print(mensaje)
	audio_player.stop()  # Detener la música
	juego_en_curso = false  # Marcar que el juego ha terminado
	var game_over_scene = load("res://final_game/game_over.tscn").instantiate()
	get_tree().root.add_child(game_over_scene)
	game_over_scene.call_deferred("set_puntaje", puntaje)  # Pasar el puntaje a la escena de Game Over
	get_tree().current_scene = game_over_scene

func _decrementar_aburrimiento():
	if juego_en_curso:
		barra_aburrimiento.value -= 0.5
		barra_aburrimiento.value = max(0, barra_aburrimiento.value)  # Asegurar que el valor no sea negativo
		
		# Incrementar el puntaje si la barra de aburrimiento ha bajado de nivel
		if int(barra_aburrimiento.value) < int(aburrimiento_anterior):
			puntaje += 1
			print(puntaje)
		
		# Actualizar el valor anterior de aburrimiento
		aburrimiento_anterior = barra_aburrimiento.value

func _decrementar_energia():
	# La barra de energía solo se decrementa cuando el perro se mueve
	pass

func _on_perro_ladro():
	barra_aburrimiento.value -= 5

# Lógica para decrementar la barra de agua
func _process(delta):
	if juego_en_curso:
		if Input.is_action_just_pressed("water"):
			if barra_agua.value > 0:
				barra_agua.value -= AGUA_DECREMENTO
				barra_aburrimiento.value -= 8.0  # Disminuir aburrimiento más rápido al usar agua
				barra_aburrimiento.value = max(0, barra_aburrimiento.value)  # Asegurar que el valor no sea negativo
				character_dog.animation.play("attack_derecha")  # Reproducir animación de
		
		# Verificar si la barra de agua llegó a 0
		if barra_agua.value <= 0:
			_fin_del_juego("La barra de agua se ha agotado. ¡Perdiste!")
