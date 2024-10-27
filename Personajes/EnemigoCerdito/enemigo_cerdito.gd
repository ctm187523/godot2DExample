extends Personajes       #heredamos de la clase Personajes


var direccion = -1  #empieza caminado a la izquierda

#inicializamos Nodos
@onready var raysuelo : RayCast2D = $RayCasts/RayCastSuelo
@onready var rayMuro : RayCast2D = $RayCasts/RayCastSMuro
@onready var rayos = $RayCasts  #contiene los 2 raycast anteriores

@onready var rayCastPlayer : RayCast2D = $RayCastPlayerDetector
@onready var anim  = $AnimationPlayer

var player

var canChangeDirection = true   #flag para manejaar el cambio de direccion pasado un pequeño tiempo y no sea instantaneo

#usamos un enum para definir los estados del cerdito(máquina de estados)
enum estados {ANGRY,PATRULLAR,MORIRSE}
var estadoActual = estados.PATRULLAR

#funciones
#funcion que se ejecuta la incio
func _ready():
	anim.play("walk")   #ponemos la animacion en walk
	speed = 60   #speed lo hereda de Personajes, le damos el valor deseado

#funcion para manejar las Físicas
func _physics_process(delta):
	velocity.x = direccion * speed    #calculamos la velocidad en x, dada por la direccion y speed
	
	#si no esta en el suelo le aplicamos gravedad
	if !is_on_floor():
		velocity.y += 9
	move_and_slide()   #funcion de Godot para aplicar el movimiento

#funcion que se ejecuta a cada frame
func _process(delta):
	
	#si el cerdito colisiona con el personaje
	#al colisionar la variable player tendra el valor de la colision, que es el player, de esta manera la condicion
	#solo se cumple si no hemos detectado al player con los raycast
	if player == null and rayCastPlayer.is_colliding():
		var colision = rayCastPlayer.get_collider() #obtenemos con get_collider con que es lo que ha colisionado el cerdito
		if colision.is_in_group("Player"):  #comprobamos que colisione con el Player
			player = colision   #a la variable player inicializada arriba le damos el valor de la colision,el player y en la condicion de esta no sera nulo el player
			estadoActual = estados.ANGRY  #cambiamos el estado 
			
			
	#si hemos colisionado con el player obtenemos en el metodo de arriba el player y
	#el cerdito toma la direccion del player, comprobamos que el estado sea Angry los raycast han detectado al player
	#lo de player != null se podria quitar ya que ya comprobamos el estado con el Angry
	if estadoActual == estados.ANGRY and  player != null:
		anim.play("runAngry")   #cambiamos el sprite al sprite del cerdito enfadado
		var directionPlayer = global_position.direction_to((player.global_position))
		if directionPlayer.x <0:    #si es menor que cero va el cerdito a la izquierda, cambiamos la direccion
			direccion=-1
		elif  directionPlayer.x > 0:
			direccion = 1			#si es mayor que cero va el cerdito a la derecha, cambiamos la direccion
		$Sprite2D.flip_h = true if direccion == 1 else false   #cambiamos la direccion cuando al cumplirse la condiciones y entrar en el if cambiamos el valor de la dirección y entonces se voltea la imagen horizontalmente

	#comprobamos que este en estado de Patrullar y a detectado al muro con sus raycast y no esta cayendo(!raysuelo.is_colliding()) y entonces cambiamos la direccion
	#al detectar el muro cambiamos la direccion y tambien el sentido del raycast
	if estadoActual == estados.PATRULLAR:
		#si  colisiona con el muro el raycast que apunta el muro lo multiplicamos
		#por -1 para cambiar la direccion
		#cambiamos tambien del grupo del Raycasts rayos inicializado arriba la scala
		#la multiplicamos por -1 y de esta manera la flecha donde apunta el raycast
		#cambia de sentido en la x, ver en el inspector de RayCast y cambiar la escala 
		# a 1 y -1 para ver como cambia el sentido de las flechas del Raycast
		if canChangeDirection and  (rayMuro.is_colliding() or !raysuelo.is_colliding()):
			canChangeDirection = false  #si cambia de direccion ponemos la variable canChangeDirection en false
			$RayCasts/RayTimer.start()  #inciamos el Timer, al acabar el Timer llama a la funcion conectada de abajo _on_ray_timer_timeout 
			direccion *= -1
			rayos.scale.x *= -1
		$Sprite2D.flip_h = true if direccion == 1 else false #cambiamos la direccion cuando al cumplirse la condiciones y entrar en el if cambiamos el valor de la dirección y entonces se voltea la imagen horizontalmente



#metodo llamado desde el script del personaje cuando los raycast que tiene horizontales hacia abajo detecta al cerdito
func takeDamage(damage):
	vida -= damage   #la varialbe vida es heredada de personajes
	if vida <=0:    #si la vida es menor o igual a cero el cerdito desaparece
		$DamagePlayer/CollisionShape2D.set_deferred("disabled", true) #desabilitamos la zona de colision al morir para que si nos mata el player ya el cerdito no pueda matar al player
		estadoActual = estados.MORIRSE  #cambiamos el estado para que de esta manera ya entra en ninguna condicion del codigo
		anim.play("hurt")  #cambiamos la animacion a herido
		$CollisionShape2D.set_deferred("disabled", true)   #desabilitamos las colisiones para que funcione correctamente y se desactive la colision cuando el enemigo muera
		await (anim.animation_finished)  #le ponemos un await para que no se ejecute el queue_free() hasta que la animacion no haya acabado
		queue_free()   #eliminamos al cerdito

#metodo de la conexion de la señal del Timer, para que al colisionar pase un tiempo
#para que no cambie del direccion al momento
func _on_ray_timer_timeout():
	canChangeDirection = true  #volvemos a poner en true la variable para que si colisiona cambie de direccion ya pasado un tiempo
	pass # Replace with function body.


