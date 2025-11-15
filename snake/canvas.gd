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
const SNAKE_BODY  := Vector2i(2, 0)
const SNAKE_TAIL  := Vector2i(3, 0)
const CROSS       := Vector2i(0, 1)
const APPLE       := Vector2i(1, 1)
const SPIKE       := Vector2i(2, 1)
const HEART       := Vector2i(3, 1)
const BORDER_BEND := Vector2i(0, 2)
const BORDER_LINE := Vector2i(1, 2)
const BRACE       := Vector2i(2, 2)


# rotation possible pour une tuile droite
const ROT_BEND_0 := 0
const ROT_BEND_1 :=  TileSetAtlasSource.TRANSFORM_FLIP_H
const ROT_BEND_2 := TileSetAtlasSource.TRANSFORM_FLIP_V
const ROT_BEND_3 := TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V


# rotation possible pour une tuile courbee
const ROT_LINE_0 := 0
const ROT_LINE_1 := TileSetAtlasSource.TRANSFORM_TRANSPOSE
const ROT_LINE_2 := TileSetAtlasSource.TRANSFORM_FLIP_H
const ROT_LINE_3 := TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V


# Nettoie l'ecran
func clear() -> void:
	canvas1.clear()
	canvas2.clear()


# Dessine un serpent dans la grille
func draw_snake(chain: Array[Vector2i]) -> void:
	# On ejecte les cas tordus qui nous embetent
	if chain.is_empty():
		printerr("Snake is empty, there is nothing to display.")
	elif chain.size() == 1:
		_draw_tile(chain[0], CROSS, 0)
	else:
		# Ici nous sommes garanti d'avoir une chaine avec au moins deux elements.
		# Nous avons simplement besoin de traiter la tete et la queue distinctement du reste du corps.
		for index in range(1, chain.size() - 2):
			var tile := _adjacent_tile(chain[index - 1], chain[index], chain[index + 1])


# Dessine une pomme dans la grille
func draw_apple(coords: Vector2i) -> void:
	_draw_tile(coords, APPLE, 0)


# Dessine une tuile dans les deux tilemap
func _draw_tile(coords: Vector2i, tile: Vector2i, alternative: int) -> void:
	canvas1.set_cell(coords, 0, tile, alternative)
	canvas2.set_cell(coords, 0, tile, alternative)


# Identifiants des tuiles composant le cors du serpent
enum BodyTile { NONE = 0, LINE = 1, BEND = 2 }


# Determine la tuile a utiliser
func _adjacent_tile(previous: Vector2i, current: Vector2i, next: Vector2i) -> Vector2i:
	# Determine l'orientation du corps du serpent d'element a element
	var orient1 := _orientation(current - previous)
	var orient2 := _orientation(next    - current)
	# TODO...
	match orient1:
		Orient.EAST:
			match orient2:
				Orient.WEST : return Vector2i(BodyTile.LINE, ROT_LINE_0)
				Orient.NORTH: return Vector2i(BodyTile.BEND, ROT_BEND_0)
				Orient.SOUTH: return Vector2i(BodyTile.BEND, ROT_BEND_0)
		Orient.NORTH:
			match orient2:
				Orient.SOUTH: return Vector2i(BodyTile.LINE, ROT_LINE_0)
				Orient.EAST : return Vector2i(BodyTile.BEND, ROT_BEND_0)
				Orient.WEST : return Vector2i(BodyTile.BEND, ROT_BEND_0)
		Orient.WEST:
			match orient2:
				Orient.EAST : return Vector2i(BodyTile.LINE, ROT_LINE_0)
				Orient.NORTH: return Vector2i(BodyTile.BEND, ROT_BEND_0)
				Orient.SOUTH: return Vector2i(BodyTile.BEND, ROT_BEND_0)
		Orient.SOUTH:
			match orient2:
				Orient.NORTH: return Vector2i(BodyTile.LINE, ROT_LINE_0)
				Orient.EAST : return Vector2i(BodyTile.BEND, ROT_BEND_0)
				Orient.WEST : return Vector2i(BodyTile.BEND, ROT_BEND_0)
	return Vector2i.ZERO


# Orientation possibles
enum Orient { EAST = 0, NORTH = 1, WEST = 2, SOUTH = 3, INVALID = -1 }

# Determine l'orientation d'un vecteur selon les quatres directions possibles
func _orientation(direction: Vector2i) -> Orient:
	if   direction == Vector2i.LEFT : return Orient.EAST
	elif direction == Vector2i.UP   : return Orient.NORTH
	elif direction == Vector2i.RIGHT: return Orient.WEST
	elif direction == Vector2i.DOWN : return Orient.SOUTH
	else: return Orient.INVALID
