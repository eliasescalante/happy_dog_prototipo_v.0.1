extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var boton = $Boton_start
	var boton_2 = $Boton_quick
	
	boton.pressed.connect(self._on_my_button_pressed)
	boton_2.pressed.connect(self._button_pressed_quick)
	$AudioStreamPlayer2D.play()

# Esta función se llamará cuando se presione el botón
func _on_my_button_pressed():
	var level = load("res://level_1/level_1.tscn")
	if level:
		get_tree().change_scene_to_packed(level)
	else:
		print("error")

func _button_pressed_quick():
	get_tree().quit()
