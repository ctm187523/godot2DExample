extends Camera2D



func _ready():
	#la camara al ser hijo del player nos sigue en todos las posiciones
	#derecha-izquieda, arriba-abajo, solo queremos que nos siga derecha-izquieda
	#con la propiedad de Godot top_levet = true le decimos a la camara que no nos siga
	#no hereda los valores del transform del player
	top_level = true  
	global_position.y = 70 #centramos la camara en y arriba-abajo, para situarla verticalmente
	
	
func _process(delta):
	#en nuestra global_position x es decir la posicion que tenemos en x
	#la igualamos a la de nuestro get_parent es decir el player
	#de esta manera la camara solo no sigue en x derecha-izquierda
	global_position.x = get_parent().global_position.x 
