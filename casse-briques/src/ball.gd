class_name GameBall extends CharacterBody2D


# Vitesse de la balle
@export_range(0.0, 100.0, 1.0, "or_greater")
var speed: float = 12.0


func _ready() -> void:
	self.reset()


func _physics_process(delta: float) -> void:
	# Déplace la balle dans une direction
	var hit := self.move_and_collide(self.velocity * delta)

	if hit != null:
		# La balle rebondi sur toute surface
		var new_dir := self.velocity.bounce(hit.get_normal())

		# Si un objet a été touché, on vérifie sa nature
		var other := hit.get_collider()

		# Si il s'agit de la raquette
		if other is GamePaddle:
			var paddle : GamePaddle = other

			# La raquette peut dévier la trajectoire de la balle 
			# end fonction d'où elle atterrie sur la raquette.
			var ang := paddle.get_deviation_angle_for(hit.get_position().x)
			new_dir = new_dir.rotated(ang)

		# Si il s'agit d'une brique
		elif other is GameBrick:
			var brick : GameBrick = other
			brick.on_hit()

		# Sinon il s'agit d'un mur

		# Après avoir déterminé la nouvelle trajectoire à suivre, 
		# nous pouvons l'appliquer à la balle.
		self.set_velocity(new_dir * self.speed)


# Stop la balle
func reset() -> void:
	self.set_physics_process(false)


# Lance la balle
func launch(dir: Vector2) -> void:
	self.velocity = dir * self.speed
	self.set_physics_process(true)
