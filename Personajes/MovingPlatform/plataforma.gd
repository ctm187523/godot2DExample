@tool                #con tool para que todo lo que corra en el process corra tambien en el editor
extends Path2D


@export var platformSpeed: float = .2   #ponemos @export para poder manipular la variable en el editor
var isRight = true   #variable para controlar las velociadades


func _process(delta):
	
	#comandos del tool añadido arriba, los dejamos vacios
	#if Engine.is_editor_hint(): #corre con el editor
		#pass
	#if not Engine.is_editor_hint():	#solo corre en el juego, si ponemos el codigo de abajo en este if en el editor no se moveria la plataforma solo se moveria en el juego
		#pass
		
	#igualamos las posiciones	
	$Plataforma.global_position = $PathFollow2D.global_position   #hacemos que la posicion global del Plataforma donde contiene el Sprite sea igual a la del PathFollow2d
	
	#si va hacia la derecha se va aumentando, controlado por la varialbe isRight
	if isRight:
		$PathFollow2D.progress_ratio += platformSpeed * delta
	#a la izquierda disminuye
	else:
		$PathFollow2D.progress_ratio -= platformSpeed * delta
	
	#progress_ratio es una propiedad de PathFollow2D ver en el inspector que es
	#la progresion del camino
	if $PathFollow2D.progress_ratio >= .95:
		isRight = false
	elif $PathFollow2D.progress_ratio <= .05:
		isRight = true
		
	#SI QUEREMOS QUE LA PLATAFORMA NO HAGA EL COMPORTAMIENTO DE ARRIBA QUE AL LLEGAR
	#A LA DERECHA DISMINUYA EL PROGRESS_RATIO Y VAYA HACIA LA IZQUIERDA Y HACEMOS
	#QUE EL MOVIMIENTO SEA CIRCULAR PODEMOS USAR EL SIGUIENTE CODIGO, COMENTADO
	#SUSTITUYENDO EL CODIGO DESDE LINEA 20 HASTA LINEA 31,EL CODIGO DE ARRIBA SERIA
	#MAS PARA UN MOVIMIENTO LINEAR DE IDA Y VUELTA EL DE ABAJO SERIA PARA MOVIMIENTO CIRCULAR
	#if $PathFollow2D.progress_ratio < 1:
		#$PathFollow2D.progress_ratio += platformSpeed * delta
	#else:
		#$PathFollow2D.progress_ratio = 0  #reseteamos a cero el ratio
