class_name Grid2D

#region PROPERTIES

# Taille de la surface de jeu
@export
var dimensions := Vector2i(12, 12):
	set(value):
		dimensions = value
		_matrix.resize(dimensions.x * dimensions.y)


# Matrice interne de bytes
var _matrix := PackedByteArray()

# Cellule vide
const EMPTY := 0

# Marqueur pour indiquer qu'un index est en dehors de la matrice
const INVALID_INDEX := -1

#endregion


#region PUBLIC METHODS

# Remet tous les élements de la grille à zéro
func clear() -> void:
	_matrix.fill(EMPTY)


# Obtient la valeur stockée à la position fournie
func get_cell(position: Vector2i) -> int:
	var index := _index(position)
	if  index != INVALID_INDEX:
		return _matrix.get(index)
	else:
		return EMPTY


# Stocke une valeur à la position fournie
func set_cell(position: Vector2i, value: int) -> void:
	var index := _index(position)
	if  index != INVALID_INDEX:
		_matrix.set(index, value)

#endregion


#region PRIVATE METHODS

# Calcule un index pour accéder la matrice interne
func _index(p: Vector2i) -> int:
	if p.x < 0 or dimensions.x <= p.x or p.y < 0 or dimensions.y <= p.y:
		return INVALID_INDEX
	else:
		return p.x + p.y * dimensions.x

#endregion
