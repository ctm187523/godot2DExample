#hereda del script playerState.gd este hereda de state.gd 
#ademas tiene la propiedad owner del Player de esta manera
#al referenciar a las propiedaes del Player no tenemos que poner
#owner y asi nos sale el autocompletado de los metodos
#ESTO HABRIA QUE HACERLO EN LOS DEMAS ESTADOS PERO LO DEJAMOS 
#SOLO AQUI PARA VER COMO SERIA EN LOS OTROS ESTADOS SI NO HEREDAN
#DE PlayerState
extends PlayerState     

var hasJumped = false #variable para controlar que solo haga el doble salto si esta en el aire, si esta en salto
'''
¿Qué es el Coyote Time?

 En términos simples, el Coyote Time es una técnica de 
programación en videojuegos que permite a un personaje 
saltar un poco después de haberse separado de una plataforma.
 Es como si el personaje tuviera un breve período de gracia 
donde puede realizar un salto, incluso si técnicamente ya 
está cayendo. Esto se inspira en las clásicas animaciones de 
los Looney Tunes donde el Coyote, justo antes de caer al vacío,
parece flotar por un instante antes de caer.
he agredao 2 timers en el player hijos del estado enAire
'''

'''
¿Qué es el Jump Buffer?
El jump buffer es una técnica de programación en videojuegos
que permite a los jugadores realizar un salto incluso si
 presionan el botón de salto justo antes de tocar el suelo. 
Es como si el juego "guardara" la intención del jugador de 
saltar durante un breve período de tiempo, permitiendo que 
el salto se ejecute un poco más tarde.

¿Por qué es útil?

Mejora la jugabilidad: Hace que los juegos se sientan más 
responsivos y fluidos.
Reduce la frustración: Evita que los jugadores se pierdan 
saltos por fracciones de segundo.
Aumenta la sensación de control: Los jugadores perciben que 
tienen un mayor control sobre sus personajes.
'''
var isFalling = false #variable para saber si el personaje esta cayendo, usada para la tecnica coyote Timer

#usamos los metodos que tenemos en el script state.gd
func state_enter_state(msg := {}):
	
	#discriminamos el estado que recibimos por parametro para
	#tener difrentes estados, en el metodo state_process del scriot idle.gd
	#nos indica que Salto es true
	#usamos la variable player ya que heredamos de PlayerState en lugar de usar la propiedad owner del Player para referenciar al Player
	if msg.has("Salto"):
		
		hasJumped = true   #si henos saltado ponemos en true la variable creada arriba
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
	
	#para el coyoteTimer vemos si esta cayendo el personaje y damos un tiempo
	if isFalling:
		$CoyoteTimer.start()	
		
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
	
	#al saltar la variable velocity es negativa al subir y positiva la bajar
	if player.velocity.y > 0:
		isFalling = true
	else:
		isFalling = false
	
	#para la gravedad usamos la variable y si no estamos en el suelo
	#usamos la propiedad gravity del Player accedemos con owner 
	owner.velocity.y += owner.gravity 
	
	
	owner.move_and_slide() #obtenemos el metodo move_and_slide del Player. metodo ya implementado en Godot

	#si el Timer $BufferJumpTimer no esta detenido, permitimo el salto
	if !$BufferJumpTimer.is_stopped() and owner.is_on_floor():
		$BufferJumpTimer.stop()
		owner.reiniciasalto() #llamamos a la funcion del player reinicasalto para que vuelv a tener el valor de inico que es 2
		state_machine.transition_to("enAire",{Salto = true})
	#si estamos en el suelo el estado sera Idle
	if owner.is_on_floor():
		state_machine.transition_to("Idle")
	#controlamos que le Player haga el doble salto solo si numSAltos es mayor que 0
	#usamos la variable hasJumped creada arriba y controlada en state_physics_process, para controlar que solo haga el doble salto si enta en salto
	elif hasJumped and Input.is_action_just_pressed("ui_accept") and owner.numSaltos > 0:
		state_machine.transition_to("enAire",{Salto = true}) #mismo linea de codigo en en el estado Idle
		hasJumped = false #ponemos la varialbe en false
	#ponemos la condicion que si el Timer CoyoteTimer no ha parada y pulsamos espacio, pueda saltar
	#usamos este Timer para dar un impulso extra
	elif !$CoyoteTimer.is_stopped()and Input.is_action_just_pressed("ui_accept"):
		state_machine.transition_to("enAire",{Salto = true})
	#si ninguno de los saltos es posible debido a las condiciones anteriores usamos el Timer BufferJumpTimer
	#JUMP BUFFER
	elif Input.is_action_just_pressed("ui_accept"):
		$BufferJumpTimer.start()
