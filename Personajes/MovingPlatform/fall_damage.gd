extends Area2D


#señal conectada de FallDamage, para que al entrar el Player
#le dañe enormemente
func _on_body_entered(body):
	if body is Player:
		body.takeDamage(9999)
