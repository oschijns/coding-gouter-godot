class_name SnakeGame extends Node


"""
	Script principal permettant de gérer la logique du jeu.
"""


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

# Speaker pour jouer des bips sonores
@onready
var speaker: Speaker = $Speaker


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
	_on_game_start()


# Fonction appelée ~60 fois par seconde
func _process(_delta: float) -> void:

	# Réinitialize le jeu
	if game_over and Input.is_action_just_pressed(&"restrart_game"):
		_on_game_start()

	# Quitte le jeu
	if Input.is_action_just_pressed(&"quit_game"):
		get_tree().quit()

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
		# Jouer un son lorsqu'on mange la pomme
		speaker.play_beep()

	# Nous nous déplaçons vers une case vide
	else:
		snake_positions.pop_back()

	# Fait avancer le serpent
	snake_positions.push_front(next)

	# On redessine tout le jeu
	canvas.clear()
	canvas.draw_play_area_border()
	canvas.draw_snake(snake_positions)
	canvas.draw_apple(apple_position)
	canvas.draw_text(Vector2i(2, 0), "score %d" % score)

	if game_over:
		_on_game_over()

#endregion


#region PRIVATE METHODS

# Fonction à appeler pour démarrer le jeu
func _on_game_start() -> void:
	# Initialisation du jeu:
	# - Positionner le serpent
	# - Ajouter une pomme

	# Réinitialize l'état du jeu si nous recommençons une partie
	game_over = false
	score = 0

	# Positionnement du serpent
	var center := canvas.play_area.get_center()
	snake_positions.clear()
	snake_positions.push_back(center)
	snake_positions.push_back(center + Vector2i.UP)
	direction_handler.init_direction(Vector2i.DOWN)

	# Positionnement d'une pomme
	apple_position = _get_random_position()

	# Le jeu peut démarrer
	tick_rate.start()
	print("Snake Game ready.")


# Fonction à appeler pour terminer le jeu
func _on_game_over() -> void:
	print("GAME OVER score: %d" % score)

	# On affiche une croix sur toutes les positions 
	# qui étaient occupées par le serpent.
	for pos in snake_positions:
		canvas.draw_cross(pos)

	canvas.draw_text(Vector2i(2, 0), "game over")

	# On arrête d'actualiser le jeu
	tick_rate.stop()


# Renvoie une position aléatoire dans la zone de jeu
func _get_random_position() -> Vector2i:
	var area := canvas.play_area
	return Vector2i(
		randi_range(area.position.x + 1, area.end.x - 1),
		randi_range(area.position.y + 1, area.end.y - 1)
	)


#endregion
