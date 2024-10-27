#hereda del script playerState.gd este hereda de state.gd 
#ademas tiene la propiedad owner del Player de esta manera
#al referenciar a las propiedaes del Player no tenemos que poner
#owner y asi nos sale el autocompletado de los metodos
#ESTO HABRIA QUE HACERLO EN LOS DEMAS ESTADOS PERO LO DEJAMOS 
#SOLO AQUI PARA VER COMO SERIA EN LOS OTROS ESTADOS SI NO HEREDAN
#DE PlayerState
extends PlayerState     



#usamos los metodos que tenemos en el script state.gd

func state_enter_state(msg := {}):
	
	#discriminamos el estado que recibimos por parametro para
	#tener difrentes estados, en el metodo state_process del scriot idle.gd
	#nos indica que Salto es true
	#usamos la variable player ya que heredamos de PlayerState en lugar de usar la propiedad owner del Player para referenciar al Player
	if msg.has("Salto"):
		#usamos la variable numSaltos del Player para controlar el doble salto que solo sea de 2 saltos
		player.numSaltos -=1  #restamos un salto de los 2, para el doble salto
		
		$"../../AudioSalto".play()  #ponemos el audio para el salto, arrastrandolo aqui
		anim_player.play("jump") #ponemos la animacion de saltar
		player.velocity.y = -player.jump   #modificamos la y, para que salte 
	
		#cambiamos la animacion para el doble salto
		if owner.numSaltos  == 0:
			anim_player.play("jumpDoble")
	else:
		anim_player.play("jumpCaer") #cambiamos la animacion a jumpCaer
		
		
#funcion llamada en Idle cuando no detecta suelo	
func state_physics_process(delta):
	#obtenemos la entrada de teclado/mandos/etc, en derecha e izquierda valores de -1 a 1
	var direccion = Input.get_axis("ui_left","ui_right")
	
	
	#volteamos al Player al cambiar de direccion, usamos player para referenciar al Player ver al inicio del código
	#usamos la propiedad sprite del Player sprite que la inicializa asi -> @onready var sprite := $Sprite2D
	player.sprite.flip_h = direccion < 0 if direccion != 0 else player.sprite.flip_h
	
	#hacemos que se mueve obteniendo las variables del Player
	#con owner accedemos a las variables del player, no lo usamos ver arriba del codigo
	#En godot 4 los CharacterBody2D ya tienen la propiedad de velocity
	#el Nodo raiz del Player es un CharacterBody que le hemos llamado Player
	player.velocity.x = direccion * player.spped  #la variable velocity ya viene implementada en CharacterBody2D, es de tipo Vector2, la variable spped la obtenemos del padre
	
	#para la gravedad usamos la variable y si no estamos en el suelo
	#usamos la propiedad gravity del Player accedemos con owner 
	owner.velocity.y += owner.gravity 
	
	
	owner.move_and_slide() #obtenemos el metodo move_and_slide del Player. metodo ya implementado en Godot

	#si estamos en el suelo el estado sera Idle
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	#controlamos que le Player haga el doble salto solo si numSAltos es mayor que 0
	elif Input.is_action_just_pressed("ui_accept") and owner.numSaltos > 0:
		state_machine.transition_to("enAire",{Salto = true}) #mismo linea de codigo en en el estado Idle
