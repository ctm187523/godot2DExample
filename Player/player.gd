extends CharacterBody2D


var spped := 120
var direccion := 0.0
const gravity := 9
var jump := 260

#inicializamos la variable $AnimationPlayer para manejar las animaciones
@onready var anim := $AnimationPlayer

#inicializamos la variable $Sprite2D
@onready var sprite := $Sprite2D

func _physics_process(delta):
	
	#En godot 4 los CharacterBody2D ya tienen la propiedad de velocity
	#get_axis nos devuelve -1 si vamos a la izquierda y 1 si vamos a la derecha
	direccion = Input.get_axis("ui_left","ui_right")
	#velocity ya implementado en CharacterBody2d es de tipo 2D
	#como no estamos usando un Vector de tipo 2d en la variable direccion, es un float
	#ponemos velocity.x para usar solo un componente del Vectro2d si tambien nos movieramos
	#de arriba a abajo direccion deberia ser de tipo Vector2d pero solo queremos movernos
	#de derecha a izquierda, usar otra variable para velocity.y
	velocity.x = direccion * spped  #la variable velocity ya viene implementada en CharacterBody2D, es de tipo Vector2
	
	
	#si la direccion es diferente de 0 quiere decir que esta caminando
	#le damos la animacion de caminar,usamos la variable creada arriba anim para las animaciones
	if direccion !=0:
		anim.play("walk")
	else:
		anim.play("idle")
	
	#usamos la propiedad flip_h(voltear hotizontal), filp_b(voltear vertical) de sprite para voltear hacia derecha o izquierda el sprite
	#fijarse que en el inspector esta esa propiedad como booleano activad-desactivado
	#usamos un if terciaro para que al ir hacia la izquierda y pararse no se gire hacia la derecha mantenga la posicion izquierda
	sprite.flip_h = direccion < 0 if direccion != 0 else sprite.flip_h
	
	#añadimos un salto,al presionar espacio
	#usamos is_on_floor() para que solo pueda saltar si esta en el suelo y no haga repetidos saltos sin haber caido
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y -= jump   #modificamos la y
	
	
	#añadimos gravedad, ahora usamos la componente y de velocity
	#ponemos la condicion que la gravedad solo se aplique si no esta en el suelo.
	if !is_on_floor():
		velocity.y += gravity   #move_and_slide() ya trabaja con delta no hace falta multiplicar por delta
	
	# ver documentación de Godot: 
	# Moves the body based on velocity. If the body collides with another, it will slide along the other body (by default only on floor) 
	# rather than stop immediately. If the other body is a CharacterBody2D or RigidBody2D, it will also be affected by the motion of the other body. 
	# You can use this to make moving and rotating platforms, or to make nodes push other nodes.
	move_and_slide()    #metodo ya implementado de Godot
	
