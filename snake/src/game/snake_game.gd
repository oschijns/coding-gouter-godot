class_name SnakeGame extends Node


#region PROPERTIES

# Canvas pour dessiner le jeu
@onready
var canvas: SnakeCanvas = $SnakeCanvas

# Manager pour la direction
@onready
var direction_handler: DirectionHandler = $DirectionHandler

# Métronome pour cadencer le jeu
@onready
var tick_rate: Timer = $TickRate

# Drapeau pour indiquer si le jeu est perdu
var game_over := false

# Compteur de points
var score := 0

# Les positions occupées par le serpent
var snake_positions: Array[Vector2i] = []

# La position occupée par la pomme
var apple_position := Vector2i.ZERO

#endregion


#region GODOT's METHODS

# Fonction appelée au démarrage du jeu
func _ready() -> void:
	# Initialisation du jeu:
	# - Positionner le serpent
	# - Ajouter une pomme

	var center := canvas.play_area.get_center()
	snake_positions.push_back(center)
	snake_positions.push_back(center + Vector2i.UP)
	direction_handler.direction_current = Vector2i.DOWN

	apple_position = _get_random_position()

	print("Snake Game ready.")


# Fonction appelée 60 fois par seconde
#func _process(delta: float) -> void: pass

#endregion


#region CALLBACK METHODS

# Appelé par le Timer TickRate
func _on_tick() -> void:

	# Quelle direction suivre pour ce tick?
	var direction := direction_handler.pull_direction()

	# Où se trouve le serpent?
	var head := snake_positions[0]
	var next := head + direction

	# Allons-nous nous mordre nous même?
	# Allons-nous collisioner la bordure du terrain?
	if next in snake_positions or not canvas.play_area.has_point(next):
		game_over = true

	# Allons-nous manger la pomme?
	elif next == apple_position:
		score += 1
		apple_position = _get_random_position()

	# Nous nous déplaçons vers une case vide
	else:
		snake_positions.pop_back()

	# Fait avancer le serpent
	snake_positions.push_front(next)

	canvas.clear()
	canvas.draw_snake(snake_positions)
	canvas.draw_apple(apple_position)

	if game_over:
		_on_game_over()

#endregion


#region PRIVATE METHODS

# Renvoie une position aléatoire dans la zone de jeu
func _get_random_position() -> Vector2i:
	var area := canvas.play_area
	return Vector2i(
		randi_range(area.position.x, area.end.x),
		randi_range(area.position.y, area.end.y)
	)

# Fonction a appeler pour terminer le jeu
func _on_game_over() -> void:
	print("GAME OVER")

	for pos in snake_positions:
		canvas.draw_cross(pos)

	# On arrête d'actualiser le jeu
	tick_rate.stop()

#endregion
