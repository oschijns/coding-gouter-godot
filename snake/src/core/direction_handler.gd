class_name DirectionHandler extends Node

"""
	Permet de lire une direction à chaque frame 
	mais en l'appliquant à une cadence régulière.
"""

#region PROPERTIES

# Actions à lire
@export var move_up    := &"move_up"
@export var move_down  := &"move_down"
@export var move_left  := &"move_left"
@export var move_right := &"move_right"

# Deadzone du joystick
@export_range(0.0, 1.0)
var deadzone := 0.1

# Direction actuelle et future du serpent
var direction_current := Vector2i.ZERO
var direction_next    := Vector2i.ZERO

#endregion


#region GODOT's METHODS

# Fonction appelée 60 fois par seconde
func _process(delta: float) -> void:
	# Une fois la direction lue à partir de la manette.
	# On la compare à la direction actuelle du serpent pour déterminer la direction 
	# qui sera effectivement appliquée.
	var direction := _read_direction()

	# Le joueur n'a pas sélectionné de direction ou il a choisi une direction 
	# strictement opposée à la direction précédente.
	# => On conserve la direction précédente.
	if not (direction == Vector2i.ZERO 
		or direction.x == -direction_current.x 
		or direction.y == -direction_current.y
	):
		direction_next = direction

#endregion


#region PRIVATE METHODS

# À appeler lorsqu'on veut obtenir une nouvelle direction à appliquer au serpent
func pull_direction() -> Vector2i:
	# Stockage de la direction trouvée pour être utilisé comme référence au prochain tick
	if direction_next != Vector2i.ZERO:
		direction_current = direction_next
	return direction_current

#endregion


#region PRIVATE METHODS

# Obtenir la direction voulu par le joueur
func _read_direction() -> Vector2i:
	var direction := Vector2i.ZERO

	# Lire la direction du joystick sous forme d'un vecteur 2D [-1.0, 1.0]
	var joystick := Input.get_vector(move_left, move_right, move_up, move_down, deadzone)
	if not joystick.is_zero_approx():

		# On veut prendre en compte l'axe principal
		match joystick.abs().max_axis_index():
			Vector2.AXIS_X: direction.x = sign(joystick.x)
			Vector2.AXIS_Y: direction.y = sign(joystick.y)

	return direction

#endregion
