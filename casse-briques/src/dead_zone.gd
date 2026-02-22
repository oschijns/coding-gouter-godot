class_name GameDeadZone extends Area2D


# Émettre un signal lorsque la balle rentre dans la dead zone 
signal ball_lost


# Detecte lorsque la balle entre dans cette zone
func body_entered(body: Node2D) -> void:
	if body is GameBall:
		self.emit_signal(&"ball_lost")
