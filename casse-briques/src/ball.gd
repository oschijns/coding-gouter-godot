class_name GameBall extends CharacterBody2D


#region ATTRIBUTES

# Vitesse de la balle
@export_range(0.0, 600.0, 1.0, "or_greater")
var speed : float = 500.0

# Rayon de la balle
var radius : float

# Indique si la balle est arrêté, en attente d'être lancée
var flag_stopped := true

#endregion


#region GODOT's METHODS

func _ready() -> void:
	self.radius = $Collider.shape.radius
	self.reset()


func _physics_process(delta: float) -> void:
	# Déplace la balle dans une direction
	var hit := self.move_and_collide(self.velocity * delta)

	if hit != null:
		# La balle rebondi sur toute surface
		var new_dir := self.velocity.bounce(hit.get_normal()).normalized()

		# Si un objet a été touché, on vérifie sa nature
		var other := hit.get_collider()

		# Si il s'agit de la raquette
		if other is GamePaddle:
			var paddle : GamePaddle = other

			# La raquette peut dévier la trajectoire de la balle 
			# end fonction d'où elle atterrie sur la raquette.
			var hit_pos := hit.get_position() - self.global_position
			var ang := paddle.get_deviation_angle_for(hit_pos.x)
			print("angle: ", ang)
			new_dir = new_dir.rotated(ang)

		# Si il s'agit d'une brique
		elif other is GameBrick:
			var brick : GameBrick = other
			brick.on_hit()

		# Sinon il s'agit d'un mur

		# Après avoir déterminé la nouvelle trajectoire à suivre, 
		# nous pouvons l'appliquer à la balle.
		self.set_velocity(new_dir * self.speed)

#endregion


#region CUSTOM METHODS

# On détache la balle de son parent actuelle, 
# pour la rattacher à un nouveau parent.
func reattach_to(node: CanvasItem) -> void:
	var parent := self.get_parent()
	if node != null and parent != null:
		var pos := self.global_position
		parent.remove_child(self)
		node.add_child(self)
		self.set_global_position(pos)


# Stop la balle
func reset() -> void:
	self.set_physics_process(false)
	self.flag_stopped = true


# Lance la balle
func launch(dir: Vector2) -> void:
	self.velocity = dir.normalized() * self.speed
	self.set_physics_process(true)
	self.flag_stopped = false

#endregion
