extends State     #hereda del script state.gd


#usamos los metodos que tenemos en el script state.gd

func state_enter_state(msg := {}):
	#accedemos a la variable velocity del Player(player.gd)
	#con owner accedemos a la raiz del Nodo el Player
	#reiniciamos a cero la velocidad
	#En godot 4 los CharacterBody2D ya tienen la propiedad de velocity
	#el Nodo raiz del Player es un CharacterBody que le hemos llamado Player
	owner.velocity = Vector2.ZERO  
	#obtenemos la animacion del AnimationPlayer del Player
	#asignado en el Inspector gracias a la propiedad que hereda
	#del script state.gd anim_player
	#usamos la variable anim_player para poner la animacion de idle
	anim_player.play("idle")  
	
	
	
func state_process(delta):
	#obtenemos la entrada de teclado/mandos/etc, en derecha e izquierda valores de -1 a 1
	var direccion = Input.get_axis("ui_left","ui_right")

	if direccion != 0:
		#usamos la variable state_machine del padre state.gd y su metodo transition_to
		#para cambiar el estado, este metodo es del script stateMachine.gd
		#en el codigo de stateMachine.gd recorremos con un bucle For en
		#la funcion _ready y a sus hijos le añadimos el stateMachine en la propiedad
		#state_machine del script state.gd
		state_machine.transition_to("Moving") #al moverse cambiamos el estado a Moving
	elif !owner.is_on_floor():   #si no estamos en el suelo cambiamos al estado enAire
		state_machine.transition_to("enAire")
	elif Input.is_action_just_pressed("ui_accept"):
		#si pulsamos espacio queremos saltar pasamos al estado enAire
		#y le pasamos el segundo parametro opcional que es un diccionario
		#indicando que salto es true
		#en el metodo state_enter_state del script enAire.gd comprueba
		#que el mensaje sea Salto para realizar una accion
		state_machine.transition_to("enAire",{Salto = true})

