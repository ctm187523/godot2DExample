extends Area2D



#conectamos la señal
func _on_body_entered(body):
	if body is Player:    #referenciamos a la clase Player en el script del Player hemos creado class_name Player
		Global.frutas+=1   #hemos creado una escena que llamamos global donde tenemos variables globales(singleton) que podemos usarlas en otras escenas, ver en libreta o video 51 minuto 5 
		
		
		queue_free()   #al colisionar con el jugador se destruye la fruta, recoleccion de frutas
