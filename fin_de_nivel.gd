extends Area2D


#al poner @export en el inspector sale la variable esta creada y podemos arrastrar
#el nivel que queremos que aparezca, en la varaible siguienteNivel pegamos la ruta
#del siguiente nivel que sera world2
@export var siguienteNivel: String 



#señal conectada del Nodo raiz FinDenivel
func _on_body_entered(body):
	if body is Player:
		get_tree().change_scene_to_file(siguienteNivel)  #llamamos si alcanzamos la copa al siguiente nivel
