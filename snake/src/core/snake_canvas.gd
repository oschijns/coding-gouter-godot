class_name SnakeCanvas extends Node

#region PROPERTIES

# Taille de la surface de jeu
@export
var play_area := Rect2i(0, 0, 23, 12)

# Liste des calques sur lequels écrire les tuiles
@export
var canvas_layers: Array[TileMapLayer] = []

#endregion


#region PUBLIC METHODS

# Nettoie l'écran
func clear() -> void:
	for layer in canvas_layers:
		layer.clear()


# Dessine une pomme dans la grille
func draw_apple(coords: Vector2i) -> void:
	_draw_tile(coords, APPLE, 0)


# Dessine une boule d'épines dans la grille
func draw_spike(coords: Vector2i) -> void:
	_draw_tile(coords, SPIKE, 0)


# Dessine un coeur dans la grille
func draw_heart(coords: Vector2i) -> void:
	_draw_tile(coords, HEART, 0)


# Dessine un serpent dans la grille
func draw_snake(chain: Array[Vector2i]) -> void:
	# Pour dessiner un serpent, on parcours la chaîne du début à la fin en 
	# comparant chaque maillon avec ses voisins. Cela permet de vérifier si un 
	# maillon doit être droit ou courbé et son orientation. La tête et la queue 
	# sont deux cas particuliers qui sont traîté indépendament.

	# longueur de la chaîne
	var length := chain.size()

	# On éjecte les cas tordus qui nous embêtent
	if chain.is_empty():
		printerr("Snake is empty, there is nothing to display.")
	elif length == 1:
		_draw_tile(chain[0], CROSS, 0)
	else:
		# Pour identifier la tuile a dessiner, son orientation et sa position
		var tile_pos  : Vector2i
		var tile_data : Vector3i

		# Ici nous sommes garanti d'avoir une chaîne avec au moins deux élements.
		# Nous avons simplement besoin de traîter la tête et la queue distinctement du reste du corps.
		tile_pos  = chain[0]
		tile_data = _pick_snake_tile_end(tile_pos, chain[1], SNAKE_HEAD)
		_draw_tile2(tile_pos, tile_data)

		for index in range(1, length - 1):
			tile_pos  = chain[index]
			tile_data = _pick_snake_tile_middle(chain[index - 1], tile_pos, chain[index + 1])
			_draw_tile2(tile_pos, tile_data)

		tile_pos  = chain[length - 1]
		tile_data = _pick_snake_tile_end(tile_pos, chain[length - 2], SNAKE_TAIL)
		_draw_tile2(tile_pos, tile_data)


# Dessine une bordure autour de la zone de jeu
func draw_border() -> void:
	# Pour dessiner une bordure, nous avons simplement besoin de dessiner
	# - deux lignes horizontales
	# - deux lignes verticales
	# - quatres coins

	# On récupère les limites de la zone de jeu
	var x0 := play_area.position.x
	var x1 := play_area.end.x
	var y0 := play_area.position.y
	var y1 := play_area.end.y
	
	# On trace les deux lignes horizontales en même temps
	for x in range(x0 + 1, x1 - 1):
		_draw_tile(Vector2i(x, y0), BORDER_LINE, RotLine.H)
		_draw_tile(Vector2i(x, y1), BORDER_LINE, RotLine.H)

	# On trace les deux lignes verticales en même temps
	for y in range(y0 + 1, y1 - 1):
		_draw_tile(Vector2i(x0, y), BORDER_LINE, RotLine.V)
		_draw_tile(Vector2i(x1, y), BORDER_LINE, RotLine.V)

	# On trace les quatres coins
	_draw_tile(Vector2i(x0, y0), BORDER_BEND, RotBend.NW)
	_draw_tile(Vector2i(x1, y0), BORDER_BEND, RotBend.NE)
	_draw_tile(Vector2i(x0, y1), BORDER_BEND, RotBend.SW)
	_draw_tile(Vector2i(x1, y1), BORDER_BEND, RotBend.SE)

#endregion


#region PRIVATE METHODS

# Dessine une tuile dans les deux tilemaps
func _draw_tile(coords: Vector2i, tile: Vector2i, alternative: int) -> void:
	for layer in canvas_layers:
		layer.set_cell(coords, 0, tile, alternative)


# Dessine une tuile dans les deux tilemaps
func _draw_tile2(coords: Vector2i, tile: Vector3i) -> void:
	var pos := Vector2i(tile.x, tile.y)
	for layer in canvas_layers:
		layer.set_cell(coords, 0, pos, tile.z)


# Détermine la tuile a utiliser
static func _pick_snake_tile_end(previous: Vector2i, next: Vector2i, tile: Vector2i) -> Vector3i:
	match _orientation(next - previous):
		Orient.EAST : return Vector3i(tile.x, tile.y, RotEnd.EAST )
		Orient.NORTH: return Vector3i(tile.x, tile.y, RotEnd.NORTH)
		Orient.WEST : return Vector3i(tile.x, tile.y, RotEnd.WEST )
		Orient.SOUTH: return Vector3i(tile.x, tile.y, RotEnd.SOUTH)
	return Vector3i(CROSS.x, CROSS.y, 0)


# Détermine la tuile a utiliser
static func _pick_snake_tile_middle(previous: Vector2i, current: Vector2i, next: Vector2i) -> Vector3i:
	# Détermine l'orientation du corps du serpent d'élement a élement
	var orient1 := _orientation(current - previous)
	var orient2 := _orientation(current - next)
	match orient1:
		Orient.EAST:
			match orient2:
				Orient.WEST : return Vector3i(SNAKE_LINE.x, SNAKE_LINE.y, RotLine.H)
				Orient.NORTH: return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.NE)
				Orient.SOUTH: return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.SE)
		Orient.NORTH:
			match orient2:
				Orient.SOUTH: return Vector3i(SNAKE_LINE.x, SNAKE_LINE.y, RotLine.V)
				Orient.EAST : return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.NE)
				Orient.WEST : return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.NW)
		Orient.WEST:
			match orient2:
				Orient.EAST : return Vector3i(SNAKE_LINE.x, SNAKE_LINE.y, RotLine.H)
				Orient.NORTH: return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.NW)
				Orient.SOUTH: return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.SW)
		Orient.SOUTH:
			match orient2:
				Orient.NORTH: return Vector3i(SNAKE_LINE.x, SNAKE_LINE.y, RotLine.V)
				Orient.EAST : return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.SE)
				Orient.WEST : return Vector3i(SNAKE_BEND.x, SNAKE_BEND.y, RotBend.SW)
	return Vector3i(CROSS.x, CROSS.y, 0)


# Détermine l'orientation d'un vecteur selon les quatres directions possibles
static func _orientation(direction: Vector2i) -> Orient:
	if   direction == Vector2i.LEFT : return Orient.EAST
	elif direction == Vector2i.UP   : return Orient.NORTH
	elif direction == Vector2i.RIGHT: return Orient.WEST
	elif direction == Vector2i.DOWN : return Orient.SOUTH
	else: return Orient.INVALID

#endregion


#region CONSTANTS

# position des tuiles dans le tileset
const SNAKE_HEAD  := Vector2i(0, 0)
const SNAKE_BEND  := Vector2i(1, 0)
const SNAKE_LINE  := Vector2i(2, 0)
const SNAKE_TAIL  := Vector2i(3, 0)
const CROSS       := Vector2i(0, 1)
const APPLE       := Vector2i(1, 1)
const SPIKE       := Vector2i(2, 1)
const HEART       := Vector2i(3, 1)
const BORDER_BEND := Vector2i(0, 2)
const BORDER_LINE := Vector2i(1, 2)
const BRACE       := Vector2i(2, 2)


# rotations possibles pour une tuile terminale
enum RotEnd {
	EAST  = TileSetAtlasSource.TRANSFORM_TRANSPOSE,
	NORTH = 0,
	WEST  = TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_H,
	SOUTH = TileSetAtlasSource.TRANSFORM_FLIP_V,
}

# rotations possibles pour une tuile courbée
enum RotBend {
	NE = 0,
	NW = TileSetAtlasSource.TRANSFORM_FLIP_H,
	SW = TileSetAtlasSource.TRANSFORM_FLIP_V | TileSetAtlasSource.TRANSFORM_FLIP_H,
	SE = TileSetAtlasSource.TRANSFORM_FLIP_V,
}

# rotations possibles pour une tuile droite
enum RotLine {
	H = 0,
	V = TileSetAtlasSource.TRANSFORM_TRANSPOSE,
}

# Orientation possibles
enum Orient { EAST = 0, NORTH = 1, WEST = 2, SOUTH = 3, INVALID = -1 }

#endregion
