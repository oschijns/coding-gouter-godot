class_name GamePaddle extends AnimatableBody2D


# Vitesse de la raquette
@export_range(0.0, 100.0, 1.0, "or_greater")
var speed: float = 12.0

# Permet de dévier la balle en fonction d'où elle rebondie sur la raquette
@export_range(0.0, 90.0, 1.0)
var deviation_angle := 10.0

# Définie la limite de déplacement de la raquette en partant du centre
@export_range(0.0, 640.0, 1.0, "or_greater")
var limit_range := 600.0

# Référence vers la balle
@onready
var ball : GameBall = $"../Ball"

# Largeur de la raquette
var paddle_width: float

# La raquette ne peut se déplacer que vers la gauche ou vers la droite
var move_dir := 0.0

# La raquette peut être déplacée avec la souris
var move_mouse := 0.0

# Indique si la raquette est déplacée par la souris
var flag_mouse := false


func _ready() -> void:
	var shape : CapsuleShape2D = $Collider.shape
	self.paddle_width = shape.height


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
	if Input.is_action_just_released("launch"):
		var dir := Vector2(self.move_dir, 1.0).normalized()
		self.ball.launch(dir)


func _physics_process(delta: float) -> void:
	# Déplace la raquette dans la direction choisie
	if self.flag_mouse:
		self.set_position(Vector2(self.move_mouse, 0.0))
	else:
		self.translate(Vector2(self.move_dir * (self.speed * delta), 0.0))
		
	# Si on a dépassé les limites du terrain,
	# Il faut recorriger la position.
	var limit := self.limit_range * 0.5
	var pos := clampf(self.position.x, -limit, limit)
	self.set_position(Vector2(pos, 0.0))



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


# À partir d'un point le long de la raquette,
# obtenir un angle de déviation en radians.
func get_deviation_angle_for(other_pos: float) -> float:
	var relative := other_pos - self.position.x
	var half     := self.paddle_width * 0.5
	var ratio    := inverse_lerp(-half, half, relative) * 2.0 - 1.0
	return deg_to_rad(self.deviation_angle) * ratio
	
	
