

#PlayerState hereda de state.gd pero implementa que usando Player.metodo o propedad
#aparezca en autocompletado de propiedades del Player
extends PlayerState

#cambiamos la animacion al ser herdio
func state_enter_state(msg :={}):
	anim_player.play("herido")
	player.dmgColision.set_deferred("disabled",true)  #desabilitamos la Colision de RecibirDanio ver abajo en los Nodes del Player collision encargada de recibir los daños, usamos la varaible creada en el Player que hace referencia al area de colision con los enemigos
	$"../../AudioHerirse".play()   #ponemos el audio al ser herido
	#reninicamos el movimiento del Player
	player.velocity = Vector2.ZERO
	player.move_and_slide()  #ejecutamos la accion

#al recibir daño hacemos que podamos movernos a izquierda-derecha y nos afecte la gravedad
func state_physics_process(delta):
	#obtenemos la entrada de teclado/mandos/etc, en derecha e izquierda valores de -1 a 1
	var direccion = Input.get_axis("ui_left","ui_right")
	
	#volteamos al Player al cambiar de direccion
	#usamos la propiedad sprite del Player sprite que la inicializa asi -> @onready var sprite := $Sprite2D
	player.sprite.flip_h = direccion < 0 if direccion != 0 else owner.sprite.flip_h
	
	
	#hacemos que se mueve obteniendo las variables del Player
	#con owner accedemos a las variables del player
	#En godot 4 los CharacterBody2D ya tienen la propiedad de velocity
	#el Nodo raiz del Player es un CharacterBody que le hemos llamado Player
	player.velocity.x = direccion * owner.spped  #la variable velocity ya viene implementada en CharacterBody2D, es de tipo Vector2, la variable spped la obtenemos del padre
		#para la gravedad usamos la variable y si no estamos en el suelo
	#usamos la propiedad gravity del Player accedemos con owner 
	player.velocity.y += player.gravity 
	player.move_and_slide() #obtenemos el metodo move_and_slide del Player. metodo ya implementado en Godot
	
#Señal conectada del AnimationPlayer para finalizar la animacion
#herido pasado un timpo y vaya a la animacion de Idle
func _on_animation_player_animation_finished(anim_name):
	state_machine.transition_to("Idle")
	player.dmgColision.set_deferred("disabled",false) #volvemoa a habilitar las colisiones
