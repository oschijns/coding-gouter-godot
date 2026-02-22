class_name GamePaddle extends AnimatableBody2D

#region ATTRIBUTES

# Vitesse de la raquette
@export_range(0.0, 640.0, 1.0, "or_greater")
var speed: float = 500.0

# Permet de dévier la balle en fonction d'où elle rebondie sur la raquette
@export_range(0.0, 90.0, 1.0)
var deviation_angle := 10.0

# Définie la limite de déplacement de la raquette en partant du centre
@export_range(0.0, 640.0, 1.0, "or_greater")
var limit_range := 512.0

# Référence vers la balle
@onready
var ball : GameBall = $"../Ball"

# Taille de la raquette
var paddle_size: Vector2

# La raquette ne peut se déplacer que vers la gauche ou vers la droite
var move_dir := 0.0

# La raquette peut être déplacée avec la souris
var move_mouse := 0.0

# Indique si la raquette est déplacée par la souris
var flag_mouse := false

#endregion


#region GODOT's METHODS

func _ready() -> void:
	var shape : CapsuleShape2D = $Collider.shape
	self.paddle_size = Vector2(shape.height, shape.radius * 2.0)
	self.grab_ball.call_deferred()


# Lire les inputs pour déplacer la raquette
func _process(delta: float) -> void:
	if self.flag_mouse:
		# Si la raquette est déplacée par la souris,
		# on utilise la position de la souris
		self.move_mouse = self.get_parent().get_local_mouse_position().x
		self.move_dir = clampf(Input.get_last_mouse_screen_velocity().x, -1.0, 1.0)
	else:
		# Si la raquette est déplacée via le clavier ou une manette,
		# on lit une direction
		self.move_dir = Input.get_axis("move_left", "move_right")

	# Si la balle est sur la raquette
	if self.ball.flag_stopped and Input.is_action_just_released("launch"):
		self.launch_ball()


func _physics_process(delta: float) -> void:
	var pos := self.position

	# Déplace la raquette dans la direction choisie
	if self.flag_mouse:
		pos.x = self.move_mouse
	else:
		pos.x += self.move_dir * (self.speed * delta)
		
	# Si on a dépassé les limites du terrain,
	# Il faut recorriger la position.
	var limit := self.limit_range * 0.5
	pos.x = clampf(pos.x, -limit, limit)

	self.set_position(pos)


# Quand le joueur appuie sur la touche "ESC" on veut quitter le jeu
func _input(event: InputEvent) -> void:
	if event.is_action("game_quit"):
		get_tree().quit()


# Détecte si la souris est dans la fenêtre de jeu ou non
func _notification(what: int) -> void:
	match what:
		NOTIFICATION_WM_MOUSE_ENTER:
			print("Control with mouse")
			self.flag_mouse = true
		NOTIFICATION_WM_MOUSE_EXIT:
			print("Control with keyboard")
			self.flag_mouse = false

#endregion


#region CUSTOM METHODS

# Pose la balle sur la raquette pour être lancée
func grab_ball() -> void:
	self.ball.reset()

	# On fixe la balle sur la raquette
	var place := self.paddle_size.y * -0.5 - self.ball.radius
	self.ball.reattach_to(self)
	self.ball.set_position(Vector2(0.0, place))


# Pose la balle sur la raquette pour être lancée
func launch_ball() -> void:
	# On détache la balle de la raquette
	self.ball.reattach_to(self.get_parent())

	var dir := Vector2(self.move_dir, 1.0).normalized()
	self.ball.launch(dir)


# À partir d'un point le long de la raquette,
# obtenir un angle de déviation en radians.
func get_deviation_angle_for(other_pos: float) -> float:
	var half     := self.paddle_size.x * 0.5
	var relative := clampf(other_pos - self.position.x, -half, half)
	var ratio    := inverse_lerp(-half, half, relative) * 2.0 - 1.0
	return deg_to_rad(self.deviation_angle) * ratio

#endregion
