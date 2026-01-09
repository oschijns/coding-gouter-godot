class_name SnakeGame extends Node


"""
	Script principal permettant de gérer la logique du jeu.
"""


#region PROPERTIES

# Taille de la surface de jeu
@export
var play_area := Rect2i(1, 1, 23, 12)

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

#endregion


#region GODOT's METHODS

# Fonction appelée au démarrage du jeu
func _ready() -> void:
	pass

# Fonction appelée ~60 fois par seconde
func _process(_delta: float) -> void:
	pass

#endregion


#region CALLBACK METHODS

# Appelé par le Timer TickRate
func _on_tick() -> void:
	pass

#endregion
