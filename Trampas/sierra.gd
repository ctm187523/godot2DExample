@tool     #comportamiento de la sierra en el editor
extends Node2D
var dmg = 1 

@onready var sprite =  $SierraVerdadera/Sprite #inicializamos el Sprite de la sierra
@onready var path = $Path2D/PathFollow2D  #incializamos e path
@onready var sierra = $SierraVerdadera

@export var platformSpeed: float = .2   #ponemos @export para poder manipular la variable en el editor
var isRight = true   #variable para controlar las velociadades


func _process(delta):
	sprite.rotate(deg_to_rad(450*delta))  #hacemos que la sierra rote, usamos deg_to_rad para pasar de grados a radianes, lo multiplicamos por delta para que corra igual en qualquier dispositivo
	
	#igualamos las posiciones	
	sierra.global_position = path.global_position   #hacemos que la posicion global del Plataforma donde contiene el Sprite sea igual a la del PathFollow2d
	
	#si va hacia la derecha se va aumentando, controlado por la varialbe isRight
	if isRight:
		path.progress_ratio += platformSpeed * delta
	#hacia la izquierda disminuye 
	else:
		path.progress_ratio -= platformSpeed * delta
	
	#progress_ratio es una propiedad de PathFollow2D ver en el inspector que es
	#la progresion del camino
	if path.progress_ratio >= .95:
		isRight = false
	elif path.progress_ratio <= .05:
		isRight = true




