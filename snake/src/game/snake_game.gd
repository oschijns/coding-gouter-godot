class_name SnakeGame extends Node


#region PROPERTIES

# Canvas pour dessiner le jeu
@onready
var canvas: SnakeCanvas = $SnakeCanvas

# Métronome pour cadancer le jeu
@onready
var tick_rate: Timer = $TickRate

# Deadzone pour joysticks
const DEADZONE := 0.1

# Direction actuelle du serpent
var current_direction: Vector2i = Vector2i.DOWN

# Les positions occupées par le serpent
var snake_positions: Array[Vector2i] = []

#endregion


#region METHODS

# Fonction appelée au démarrage du jeu
func _ready() -> void:
	# Initialisation du jeu:
	# - Positionner le serpent
	# - Ajouter une pomme

	print("Snake Game ready.")


# Fonction appelée 60 fois par seconde
func _process(delta: float) -> void:
	pass


# Une fois la direction lue à partir de la manette.
# On la compare à la direction actuelle du serpent pour déterminer la direction 
# qui sera effectivement appliquée.
func _pick_direction() -> Vector2i:

	# Obtenir la direction voulu par le joueur
	var direction := _read_direction()

	# Le joueur n'a pas sélectionné de direction ou il a choisi une direction 
	# strictement opposée à la direction précédente.
	# => On conserve la direction précédente.
	if (direction == Vector2i.ZERO 
		or direction.x == -current_direction.x 
		or direction.y == -current_direction.y
	):
		direction = current_direction

	return direction


# Obtenir la direction voulu par le joueur
func _read_direction() -> Vector2i:
	var direction := Vector2i.ZERO

	# Lire la direction du joystick sous forme d'un vecteur 2D [-1.0, 1.0]
	var joystick := Input.get_vector("move_left", "move_right", "move_down", "move_up", DEADZONE)
	if not joystick.is_zero_approx():

		# On veut prendre en compte l'axe principal
		match joystick.abs().max_axis_index():
			Vector2.AXIS_X: direction.x = sign(joystick.x)
			Vector2.AXIS_Y: direction.y = sign(joystick.y)

	return direction


#endregion
