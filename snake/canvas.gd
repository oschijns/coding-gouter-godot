extends TextureRect

# Largeur de la grille
@export_range(4, 32, 1, "or_greater")
var width: int = 23

# Hauteur de la grille
@export_range(4, 32, 1, "or_greater")
var height: int = 12

# canvas d' arriere-plan utilise pour l' ombre
@onready
var canvas1: TileMapLayer = $Canvas

# canvas du premier plan pour l' effet LCD
@onready
var canvas2: TileMapLayer = $OnTop/Canvas


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

# rotations possibles pour une tuile courbee
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

# Nettoie l'ecran
func clear() -> void:
	canvas1.clear()
	canvas2.clear()


# Dessine un serpent dans la grille
func draw_snake(chain: Array[Vector2i]) -> void:
	# longueur de la chaine
	var length := chain.size()

	# On ejecte les cas tordus qui nous embetent
	if chain.is_empty():
		printerr("Snake is empty, there is nothing to display.")
	elif length == 1:
		_draw_tile(chain[0], CROSS, 0)
	else:
		# Pour identifier la tuile a dessiner, son orientation et sa position
		var tile_pos  : Vector2i
		var tile_data : Vector3i

		# Ici nous sommes garanti d'avoir une chaine avec au moins deux elements.
		# Nous avons simplement besoin de traiter la tete et la queue distinctement du reste du corps.
		tile_pos  = chain[0]
		tile_data = _pick_tile_end(tile_pos, chain[1], SNAKE_HEAD)
		_draw_tile2(tile_pos, tile_data)

		for index in range(1, length - 1):
			tile_pos  = chain[index]
			tile_data = _pick_tile_middle(chain[index - 1], tile_pos, chain[index + 1])
			_draw_tile2(tile_pos, tile_data)

		tile_pos  = chain[length - 1]
		tile_data = _pick_tile_end(tile_pos, chain[length - 2], SNAKE_TAIL)
		_draw_tile2(tile_pos, tile_data)


# Dessine une pomme dans la grille
func draw_apple(coords: Vector2i) -> void:
	_draw_tile(coords, APPLE, 0)


# Dessine une tuile dans les deux tilemap
func _draw_tile(coords: Vector2i, tile: Vector2i, alternative: int) -> void:
	canvas1.set_cell(coords, 0, tile, alternative)
	canvas2.set_cell(coords, 0, tile, alternative)


# Dessine une tuile dans les deux tilemap
func _draw_tile2(coords: Vector2i, tile: Vector3i) -> void:
	var pos := Vector2i(tile.x, tile.y)
	canvas1.set_cell(coords, 0, pos, tile.z)
	canvas2.set_cell(coords, 0, pos, tile.z)


# Determine la tuile a utiliser
static func _pick_tile_end(previous: Vector2i, next: Vector2i, tile: Vector2i) -> Vector3i:
	match _orientation(next - previous):
		Orient.EAST : return Vector3i(tile.x, tile.y, RotEnd.EAST )
		Orient.NORTH: return Vector3i(tile.x, tile.y, RotEnd.NORTH)
		Orient.WEST : return Vector3i(tile.x, tile.y, RotEnd.WEST )
		Orient.SOUTH: return Vector3i(tile.x, tile.y, RotEnd.SOUTH)
	return Vector3i(CROSS.x, CROSS.y, 0)


# Determine la tuile a utiliser
static func _pick_tile_middle(previous: Vector2i, current: Vector2i, next: Vector2i) -> Vector3i:
	# Determine l'orientation du corps du serpent d'element a element
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


# Orientation possibles
enum Orient { EAST = 0, NORTH = 1, WEST = 2, SOUTH = 3, INVALID = -1 }

# Determine l'orientation d'un vecteur selon les quatres directions possibles
static func _orientation(direction: Vector2i) -> Orient:
	if   direction == Vector2i.LEFT : return Orient.EAST
	elif direction == Vector2i.UP   : return Orient.NORTH
	elif direction == Vector2i.RIGHT: return Orient.WEST
	elif direction == Vector2i.DOWN : return Orient.SOUTH
	else: return Orient.INVALID
