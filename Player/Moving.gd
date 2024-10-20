extends State     #hereda del script state.gd


#usamos los metodos de los que hereda de state.gd
func state_physics_process(delta):
	#obtenemos la entrada de teclado/mandos/etc, en derecha e izquierda valores de -1 a 1
	var direccion = Input.get_axis("ui_left","ui_right")
	
	#volteamos al Player al cambiar de direccion
	#usamos la propiedad sprite del Player sprite que la inicializa asi -> @onready var sprite := $Sprite2D
	owner.sprite.flip_h = direccion < 0 if direccion != 0 else owner.sprite.flip_h
	
	
	#hacemos que se mueve obteniendo las variables del Player
	#con owner accedemos a las variables del player
	#En godot 4 los CharacterBody2D ya tienen la propiedad de velocity
	#el Nodo raiz del Player es un CharacterBody que le hemos llamado Player
	owner.velocity.x = direccion * owner.spped  #la variable velocity ya viene implementada en CharacterBody2D, es de tipo Vector2, la variable spped la obtenemos del padre
	owner.move_and_slide() #obtenemos el metodo move_and_slide del Player. metodo ya implementado en Godot
	
	
	#al dejar de moverse volvemos al estado de idle
	#para ello accedemos a la propiedad del script state.gd statew_machine
	#y accedemos al metodo transition_to de stateMachine.gd para cambiar
	#el estado
	if direccion == 0:
		state_machine.transition_to("Idle")
	elif !owner.is_on_floor():  #si no hau suelo cambiamos el estado a enAire
		state_machine.transition_to("enAire")
	elif Input.is_action_just_pressed("ui_accept"):
		#si pulsamos espacio queremos saltar pasamos al estado enAire
		#y le pasamos el segundo parametro opcional que es un diccionario
		#indicando que salto es true
		#en el metodo state_enter_state del script enAire.gd comprueba
		#que el mensaje sea Salto para realizar una accion
		state_machine.transition_to("enAire",{Salto = true})
	
#obtenemos la animacion del AnimationPlayer del Player
#asignado en el Inspector gracias a la propiedad que hereda
#del script state.gd anim_player
#usamos la variable anim_player para poner la animacion
func state_enter_state(msg :={}):
	#obtenemos la animacion del AnimationPlayer del Player
	#asignado en el Inspector gracias a la propiedad que hereda
	#del script state.gd anim_player
	#usamos la variable anim_player para poner la animacion
	anim_player.play("walk")
	
	
