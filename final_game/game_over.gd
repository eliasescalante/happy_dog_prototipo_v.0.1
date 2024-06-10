extends Node2D


@onready var puntaje_label = $PuntajeLabel
@onready var audio_player = $musica_final
# Called when the node enters the scene tree for the first time.

var quit_button : Button

func _ready():
	
	quit_button = $terminar
	quit_button.connect("pressed", self._on_quit_pressed)
	pass
# Esta función se llama para configurar el puntaje
func set_puntaje(puntaje: int):
	puntaje_label.text = "Puntaje: " + str(puntaje)
	# Inicia el temporizador para cerrar el juego después de 5 segundos
	

func _on_quit_pressed():
	# Cerrar el juego
	get_tree().quit()


func _on_Timer_timeout():
	get_tree().quit()
