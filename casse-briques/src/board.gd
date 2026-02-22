@tool
class_name GameBoard extends Control


#region ATTRIBUTES

# Définition de la taille de la zone de jeu
@export
var play_area := Vector2(512.0, 512.0):
	set(value):
		play_area = value
		_resize_play_area()

# Est-ce que les sous-noeuds ont été récupéré ?
var is_init := false

# Accès aux limites de la zone de jeu
var wall_top    : CollisionShape2D
var wall_left   : CollisionShape2D
var wall_right  : CollisionShape2D
var wall_bottom : CollisionShape2D


# Arrière plan de la zone de jeu
var background : ColorRect

#endregion


func _ready() -> void:
	self._init_nodes()


#region CUSTOM METHODS

# Calcul de la zone de jeu à partir de la taille de la fenêtre
func get_play_area_rectangle() -> Rect2:
	var center := Vector2(self.size) * 0.5
	var half   := self.play_area     * 0.5
	return Rect2(center - half, self.play_area)


# "_ready" n'est pas appelé dans l'éditeur
# Nous utilisons une astuce pour initialiser les sous-noeuds
func _init_nodes() -> void:
	self.wall_top    = $Game/Walls/Top
	self.wall_left   = $Game/Walls/Left
	self.wall_right  = $Game/Walls/Right
	self.wall_bottom = $Game/DeadZone/Bottom
	self.background  = $PlayArea
	self.is_init = true


# Ajuste la taille de la zone de jeu
func _resize_play_area() -> void:
	if not self.is_init:
		self._init_nodes()

	# Positionne les murs physiques
	self.wall_top   .set_position(Vector2(0.0, self.play_area.y * -0.5))
	self.wall_left  .set_position(Vector2(self.play_area.x * -0.5, 0.0))
	self.wall_right .set_position(Vector2(self.play_area.x *  0.5, 0.0))
	self.wall_bottom.set_position(Vector2(0.0, self.play_area.y *  0.5))

	# Positionne l'arrière plan
	var rect := self.get_play_area_rectangle()
	self.background.set_position(rect.position)
	self.background.set_size(rect.size + Vector2(0.0, rect.position.y))

#endregion
