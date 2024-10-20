class_name  PlayerState
extends State #hereda de state.gd

#creamos esta clase para no tener que usar cuando referenciamos
#al Player la propiedad owner, ya que usando owner no sale el
#autocompletado

#creamos una variable de tipo Player 
var player: Player

#en la funcion _ready() ponemos un await para que espera a 
#que el owner este ready
func _ready():
	await (owner.ready)
	player = owner as Player  #le damos a la variable creada arriba player la propiedad owner del Player para acceder a sus propiedades
	assert(player != null) #usamos el assert para asegurarnos de que sea verdadera la condicion, se emite un error pero no se crashea el juego
