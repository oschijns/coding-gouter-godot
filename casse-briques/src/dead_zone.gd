class_name GameDeadZone extends Area2D


# Émettre un signal lorsque la balle rentre dans la dead zone 
signal ball_lost


func _ready() -> void:
	self.body_entered.connect(self._on_body_entered)


# Detecte lorsque la balle entre dans cette zone
func _on_body_entered(body: Node2D) -> void:
	if body is GameBall:
		self.emit_signal(&"ball_lost")
