class_name State #le damos nombre a la clase ya que este sera un estado generico para que otros estados hereden de esta clase

extends Node

#variable para que se asigne la maquina de estados, se asigna en el Scrip stateMachine.gd, el script
var state_machine = null

#variable para que se asigne la animacion, la hacemos export para
#que se asigne desde el inspector, en el inspector ponemos
#el AnimationPlayer hijo del Player
@export var anim_player_path : NodePath

#asignamos la animacion de lo que se ha puesto en el inspector
@onready var anim_player = get_node(anim_player_path)

#creamos las funciones que tendran que ser implementadas en las
#clases que hereden de esta clase State
#son las clases principales state_process,state_physics_process, etc
func state_input(_event: InputEvent):
	pass

func state_process(delta):
	pass
	
func state_physics_process(delta):
	pass
	
#funcion que se ejecuta al entrar en un nuevo estado	
#recibe un parametro opcional que es un diccionario para
#decir que al entrar a un estado sea verdadero o falso
#y recibe el estado al que queremos ir
func state_enter_state(msg :={}):
	pass
	
#funcion que se ejecuta al salir de un estado
func state_exit():
	pass
