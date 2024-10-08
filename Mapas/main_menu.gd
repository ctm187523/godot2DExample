extends Node



#señal conectada del boton Button
func _on_button_pressed():
	get_tree().change_scene_to_file("res://Player/world.tscn")  #cargamos la primera escena

#señal conectada del boton Button2
func _on_button_2_pressed():
	get_tree().quit()  #boton de salida
	
	

#señal conectada del boton Button3, ponemos la pantalla a fullscreen
func _on_button_3_pressed():
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)  #cambiamos a FullScreen
