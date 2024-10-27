extends Area2D

#variable para restar vida al Player 
@export var danio = 1		

 #señal conectada con el Area2D llamada DamagePlayer para dañar al jugador
func _on_area_entered(area):
	if area.is_in_group("AreaPlayer"): #le hemos puesto nombre al Area2D RecibirDanio del Player en Grupos
		area.owner.takeDamage(danio)   #llamamos a la funcion takeDamage del Player para dañarlo, usamos owner para acceder a la raiz que es el Player 
		
