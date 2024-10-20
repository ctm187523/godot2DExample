class_name StateMachine

extends Node


#creamos signals para poder hacer transiciones entre estados
signal  cambioEstado(nombre_estado)

#variable que sera el estado inicial, ponemos @export para que
#salga en el editor y lo ponemos de tipo NodePath, para 
#poder poner el estado, seleccionamos el Node StateMachine, nodo padre
#y arrastrasmos en la propiedad del Inspector Script este Script
#stateMachine.gd de la carpeta StateMachine del Player
#ahora en el Inspector del Node StateMachine en la propiedad que
#creamos estado_inicial podemos seleccionar que estado queremos
#que sea el estado inicial
@export var estado_inicial := NodePath() 

#inicializamos el estado inicial tomandolo de la propiedad estado_inicial
@onready var state: State = get_node(estado_inicial)

#para la funcion _ready de Godot ponemos un await para esperar que la
#función ready del padre(owner) este inicializada
#la funcion _ready la emiten todos los nodos hijos de Node
func _ready():
	await (owner.ready)
	#creamos un bucle for para que en todos los estados
	#hijos Node de StateMachine la variable state_machine inicializada
	#en null en el script state.gd sea la StateMachine(node) la maquina de estados
	for child in get_children():
		child.state_machine = self    #decimos que la propiedad state_machine de los hijos del Node StateMachine seamos nosotros mismos el Node padre StateMachine la maquina de estados(state_machine) 
	state.state_enter_state()   #llamamos al metodo state_enter_state del script state.gd


#hacemos un override de los estados, sobreescribir las funciones
#usamos la funcion _unhandled_input de Godot, para manejar los eventos
'''
La función _unhandled_input en Godot se utiliza para capturar 
y procesar eventos de entrada que no han sido manejados por 
otros nodos o sistemas del juego.

¿Qué significa "no manejado"?
Un evento de entrada se considera "no manejado" cuando:

Ningún otro nodo en el árbol de escena ha reclamado el evento para su procesamiento.
Ninguna acción personalizada definida en el proyecto ha sido asignada a ese evento.
El evento no es un evento de control (como los de un gamepad) y tampoco ha colisionado con un objeto.

Para qué sirve la función _unhandled_input en Godot
La función _unhandled_input en Godot se utiliza para capturar y procesar eventos de entrada que no han sido manejados por otros nodos o sistemas del juego.

¿Qué significa "no manejado"?
Un evento de entrada se considera "no manejado" cuando:

Ningún otro nodo en el árbol de escena ha reclamado el evento para su procesamiento.
Ninguna acción personalizada definida en el proyecto ha sido asignada a ese evento.
El evento no es un evento de control (como los de un gamepad) y tampoco ha colisionado con un objeto.

¿Cuándo utilizarla?
Eventos globales: Si deseas implementar acciones que respondan a cualquier entrada del usuario, sin importar dónde se encuentre el cursor o qué nodo tenga el foco.
Eventos no asignados: Para capturar eventos que no tienen una acción específica asignada en el sistema de entrada de Godot.
Eventos que requieren un procesamiento especial: Cuando necesitas realizar un procesamiento personalizado de un evento de entrada que no se ajusta a las acciones estándar.
'''

func _unhandled_input(event):
	state.state_input(event)   #manejamos la funcion de state.gd state_input pasandole el evento

#para la funcion process delta le pasamos la funcion state_process del script state.gd
#pasandole delta por parametro
func _process(delta):
	state.state_process(delta)
	
#hacemos lo miso para la funcion _physics_process
func _physics_process(delta):
	state.state_physics_process(delta)
	
#funcion para hacer una transicion entre estados, usamos la funcion state_enter_state del script state.gd
#como parametros tenemos un mensaje de tipo String que es el estado al que va a transicionar
#y un mensaje que sera un diccionario vacio
func transition_to(target_estate: String, msg : Dictionary = {}):
	 #primero salimos del estado actual usando la funcion state_exit de state.gd
	 #creamos una condicion para controlar si tiene el parametro target_estate
	if not has_node(target_estate):
		return    #si no tenemos el estado salimos de la funcion
	state.state_exit() #salimos del estado actual
	state = get_node(target_estate)	#obtenemos el estado al que queremos ir
	state.state_enter_state(msg)  #ponemos el nuevo estado
	
	#emitimos la señal, diciendo que cambio el estado y pasandole el nombre del estado
	#la propiedad state.name dice el nombre del estado idde,moving etc
	emit_signal("cambioEstado", state.name) 
	
