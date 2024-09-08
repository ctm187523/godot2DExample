extends Node

var frutas := 0  : #usamos un set-get, frutas se actualiza en el scriot de fruta al entrar en el area, _on_body_entered de la fruta el player
	set(val):
		frutas = val
		if player != null:
			player.actualizaInterfazFrutas()  #al recolectar una fruta, se incrementa el value, llamamos al metodo actualizaInterfazFrutas() para que actualize el label que en la interfaz(PlayerGUI) que tiene el player aumente el numero de frutas recolectadas
			$frutasSonido.play() #al recolectar la fruta ejecutamos un sonido, lo ponemos en las variables globales para que no se corte en el momento que se destruye la fruta al ser recolectada
	get:
		return frutas

var player  #tenemos una referencia al jugador ver en script del Player en el método _ready() la inicializamos en cada cambio de escena
