extends CharacterBody2D

class_name  Player  #le ponemos el nombre de Player a la clase para que pueda ser referenciado en otros scripts


var spped := 120
var direccion := 0.0
const gravity := 9
var jump := 260


var damage = 1

#inicializamos la variable $AnimationPlayer para manejar las animaciones
@onready var anim := $AnimationPlayer

#inicializamos la variable $Sprite2D
@onready var sprite := $Sprite2D

#inicializamos la variable que hace referencia al Label FrutasLabel
@onready var frutasLabel := $PlayerGUI/HBoxContainer/FrutasLabel

@onready var rasycastDamage := $RaycastDamage


func _ready():
	#tenenos en la scena Global la variable player, se inicializa en cada cambio de escena
	#en cada nueva scena tenemos un nuevo jugador
	Global.player = self

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
	#fijarse que en el inspector esta esa propiedad como booleano activado-desactivado
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
	
	
func _process(delta):
	
	#a cada frame recorremos con un for todos los hijos del grupo de raycast
	#RaycastDamage, los obtenemos y comprobamos si tienen colision
	for ray in rasycastDamage.get_children():
		if ray.is_colliding():
			var colision = ray.get_collider() #en la variable colision obtenemos con quien ha colisionado los raycast
			if colision.is_in_group("Enemigos"):    #comprobamos si lo colisionado pertenece al grupo nemigos
				if colision.has_method("takeDamage"):  #comprobamos si tiene el metodo takeDamage
					colision.takeDamage(damage)   #llamamos al método takeDamage, #le pasamos el valor de la variable  damage inicializada arriba para dañar al cerdito
	
	#metodo llamado por la escene global
func actualizaInterfazFrutas():    
		frutasLabel.text = str(Global.frutas)


#funcion llamada desde el enemigo cerdito para dañar al jugador cuando entra en su Area2d llamada DamagePlayer
func takeDamage():
	morir()  #llamamos a la funcion morir
	
func morir():
	get_tree().reload_current_scene()  #al ser alcanzado por el cerdito recargamos de nuevo la escena, reiniciamos el juego
	
