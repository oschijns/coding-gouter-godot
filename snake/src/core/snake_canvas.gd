class_name SnakeCanvas extends Node

"""
	Canvas pour dessiner des tuiles à l'écran. 
"""

#region PROPERTIES

@export
var layer_handler: LayerHandler

#endregion


#region PUBLIC METHODS

# Nettoie l'écran
func clear() -> void:
	layer_handler.clear()


# Nettoie une tuile de la grille
func clear_tile(coords: Vector2i) -> void:
	layer_handler.clear_tile(coords)


# Dessine une pomme dans la grille
func draw_apple(coords: Vector2i, color: int = 0) -> void:
	layer_handler.draw_tile(coords, APPLE, 0, color)


# Dessine une boule d'épines dans la grille
func draw_spike(coords: Vector2i, color: int = 0) -> void:
	layer_handler.draw_tile(coords, SPIKE, 0, color)


# Dessine une croix dans la grille
func draw_cross(coords: Vector2i, color: int = 0) -> void:
	layer_handler.draw_tile(coords, CROSS, 0, color)


# Dessine un coeur dans la grille
func draw_heart(coords: Vector2i, color: int = 0) -> void:
	layer_handler.draw_tile(coords, HEART, 0, color)


# Dessine un serpent dans la grille
func draw_snake(chain: Array[Vector2i], color: int = 0) -> void:
	_draw_chain(SNAKE, chain, color)


# Dessine une flèche dans la grille
func draw_arrow(chain: Array[Vector2i], color: int = 0) -> void:
	_draw_chain(ARROW, chain, color)


# Dessine une bordure
func draw_border(rect: Rect2i, color: int = 0, thick := false) -> void:
	# Pour dessiner une bordure, nous avons simplement besoin de dessiner
	# - deux lignes horizontales
	# - deux lignes verticales
	# - quatres coins

	# On récupère les limites de la zone de jeu
	var x0 := rect.position.x
	var x1 := rect.end.x - 1
	var y0 := rect.position.y
	var y1 := rect.end.y - 1

	var tiles := SNAKE if thick else ARROW
	var line := tiles[IdxTile.LINE]
	var bend := tiles[IdxTile.BEND]

	# On trace les deux lignes horizontales en même temps
	for x in range(x0, x1):
		layer_handler.draw_tile(Vector2i(x, y0), line, RotLine.H, color)
		layer_handler.draw_tile(Vector2i(x, y1), line, RotLine.H, color)

	# On trace les deux lignes verticales en même temps
	for y in range(y0, y1):
		layer_handler.draw_tile(Vector2i(x0, y), line, RotLine.V, color)
		layer_handler.draw_tile(Vector2i(x1, y), line, RotLine.V, color)

	# On trace les quatres coins
	layer_handler.draw_tile(Vector2i(x0, y0), bend, RotBend.NE, color)
	layer_handler.draw_tile(Vector2i(x1, y0), bend, RotBend.NW, color)
	layer_handler.draw_tile(Vector2i(x0, y1), bend, RotBend.SE, color)
	layer_handler.draw_tile(Vector2i(x1, y1), bend, RotBend.SW, color)


# Affiche du texte à l'écran
func draw_text(coords: Vector2i, text: String, color: int = 0) -> void:
	# Converti la chaîne de caractères en majuscule puis en bytes
	var bytes  := text.to_upper().to_ascii_buffer()
	var cursor := coords

	# Dans la table ASCII, le retour à la ligne correspond à 0x0A
	const LINE_RETURN := 0x0A

	# Empty tile for white space
	const CLEAR := Vector2i(-1, -1)

	# On parcourt la chaîne caractère à caractère
	for i in range(0, bytes.size()):
		var byte := bytes.get(i)

		# Si le caractère est un retour à la ligne,
		# On déplace le curseur à l'endroit attendu.
		if byte == LINE_RETURN:
			cursor.x = coords.x
			cursor.y += 1
		else:
			var tile: Vector2i = CHARACTERS.get(byte, CLEAR)
			layer_handler.draw_tile(cursor, tile, 0, color)
			cursor.x += 1


#endregion


#region PRIVATE METHODS


# Dessine une chaine de tuiles reliée dans la grille
func _draw_chain(tiles: Array[Vector2i], chain: Array[Vector2i], color: int) -> void:
	# Pour dessiner un serpent (ou une flèche), on parcours la chaîne du début 
	# à la fin en comparant chaque maillon avec ses voisins. Cela permet de 
	# vérifier si un maillon doit être droit ou courbé et son orientation. 
	# La tête et la queue sont deux cas particuliers qui sont traîté indépendament.

	# longueur de la chaîne
	var length := chain.size()

	# On éjecte les cas tordus qui nous embêtent
	if tiles.size() < 4:
		printerr("Provided tileset does not contain enough tiles.")
	elif chain.is_empty():
		printerr("Chain is empty, there is nothing to display.")
	elif length == 1:
		layer_handler.draw_tile(chain[0], CROSS, 0, color)
	else:
		# Position de la tuile à dessiner
		var tile_pos: Vector2i

		# Ici nous sommes garanti d'avoir une chaîne avec au moins deux élements.
		# Nous avons simplement besoin de traîter la tête et la queue distinctement du reste du corps.

		# Dessine la queue
		tile_pos = chain[length - 1]
		var tile_rot := _pick_line_tile_end(tile_pos, chain[length - 2])
		layer_handler.draw_tile(tile_pos, tiles[IdxTile.TAIL], tile_rot, color)

		# Dessine le corps
		for index in range(1, length - 1):
			tile_pos = chain[index]
			var tile_data := _pick_line_tile_middle(chain[index - 1], tile_pos, chain[index + 1])
			layer_handler.draw_tile(tile_pos, tiles[tile_data.x], tile_data.y, color)

		# Dessine la tête
		tile_pos = chain[0]
		tile_rot = _pick_line_tile_end(tile_pos, chain[1])
		layer_handler.draw_tile(tile_pos, tiles[IdxTile.HEAD], tile_rot, color)


# Détermine la tuile à utiliser
static func _pick_line_tile_end(previous: Vector2i, next: Vector2i) -> int:
	match _orientation(next - previous):
		Orient.EAST : return RotEnd.EAST 
		Orient.NORTH: return RotEnd.NORTH
		Orient.WEST : return RotEnd.WEST 
		Orient.SOUTH: return RotEnd.SOUTH
	return -1


# Détermine la tuile à utiliser
static func _pick_line_tile_middle(previous: Vector2i, current: Vector2i, next: Vector2i) -> Vector2i:
	# Détermine l'orientation du corps du serpent d'élement a élement
	var orient1 := _orientation(current - previous)
	var orient2 := _orientation(current - next)
	match orient1:
		Orient.EAST:
			match orient2:
				Orient.WEST : return Vector2i(IdxTile.LINE, RotLine.H)
				Orient.NORTH: return Vector2i(IdxTile.BEND, RotBend.NE)
				Orient.SOUTH: return Vector2i(IdxTile.BEND, RotBend.SE)
		Orient.NORTH:
			match orient2:
				Orient.SOUTH: return Vector2i(IdxTile.LINE, RotLine.V)
				Orient.EAST : return Vector2i(IdxTile.BEND, RotBend.NE)
				Orient.WEST : return Vector2i(IdxTile.BEND, RotBend.NW)
		Orient.WEST:
			match orient2:
				Orient.EAST : return Vector2i(IdxTile.LINE, RotLine.H)
				Orient.NORTH: return Vector2i(IdxTile.BEND, RotBend.NW)
				Orient.SOUTH: return Vector2i(IdxTile.BEND, RotBend.SW)
		Orient.SOUTH:
			match orient2:
				Orient.NORTH: return Vector2i(IdxTile.LINE, RotLine.V)
				Orient.EAST : return Vector2i(IdxTile.BEND, RotBend.SE)
				Orient.WEST : return Vector2i(IdxTile.BEND, RotBend.SW)
	return Vector2i(-1, 0)


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
const CROSS := Vector2i(4, 0)
const APPLE := Vector2i(5, 0)
const SPIKE := Vector2i(6, 0)
const HEART := Vector2i(7, 0)

# ensemble de caractères imprimables
const CHARACTERS: Dictionary[int, Vector2i] = {
	0x30: Vector2i(4, 1), # 0
	0x31: Vector2i(5, 1), # 1
	0x32: Vector2i(6, 1), # 2
	0x33: Vector2i(7, 1), # 3
	0x34: Vector2i(0, 2), # 4
	0x35: Vector2i(1, 2), # 5
	0x36: Vector2i(2, 2), # 6
	0x37: Vector2i(3, 2), # 7
	0x38: Vector2i(4, 2), # 8
	0x39: Vector2i(5, 2), # 9

	0x41: Vector2i(6, 2), # A
	0x42: Vector2i(7, 2), # B
	0x43: Vector2i(0, 3), # C
	0x44: Vector2i(1, 3), # D
	0x45: Vector2i(2, 3), # E
	0x46: Vector2i(3, 3), # F
	0x47: Vector2i(4, 3), # G
	0x48: Vector2i(5, 3), # H
	0x49: Vector2i(6, 3), # I
	0x4A: Vector2i(7, 3), # J
	0x4B: Vector2i(0, 4), # K
	0x4C: Vector2i(1, 4), # L
	0x4D: Vector2i(2, 4), # M
	0x4E: Vector2i(3, 4), # N
	0x4F: Vector2i(4, 4), # O
	0x50: Vector2i(5, 4), # P
	0x51: Vector2i(6, 4), # Q
	0x52: Vector2i(7, 4), # R
	0x53: Vector2i(0, 5), # S
	0x54: Vector2i(1, 5), # T
	0x55: Vector2i(2, 5), # U
	0x56: Vector2i(3, 5), # V
	0x57: Vector2i(4, 5), # W
	0x58: Vector2i(5, 5), # X
	0x59: Vector2i(6, 5), # Y
	0x5A: Vector2i(7, 5), # Z
}

# Serpents et flèches peuvent suivre un tracé

const SNAKE: Array[Vector2i] = [
	Vector2i(0, 0), # head
	Vector2i(1, 0), # bend
	Vector2i(2, 0), # line
	Vector2i(3, 0)  # tail
]

const ARROW: Array[Vector2i] = [
	Vector2i(0, 1), # head
	Vector2i(1, 1), # bend
	Vector2i(2, 1), # line
	Vector2i(3, 1)  # tail
]

# quatres tuiles possibles pour dessiner serpents ou flèches
enum IdxTile {
	HEAD = 0,
	BEND = 1,
	LINE = 2,
	TAIL = 3,
}

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
