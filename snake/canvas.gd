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
const ROT_LINE_0 := 0
const ROT_LINE_1 := TileSetAtlasSource.TRANSFORM_FLIP_H
const ROT_LINE_2 := TileSetAtlasSource.TRANSFORM_FLIP_V
const ROT_LINE_3 := TileSetAtlasSource.TRANSFORM_FLIP_H | TileSetAtlasSource.TRANSFORM_FLIP_V

# rotation possible pour une tuile courbee
const ROT_BEND_0 := 0
const ROT_BEND_1 := TileSetAtlasSource.TRANSFORM_TRANSPOSE
const ROT_BEND_2 := TileSetAtlasSource.TRANSFORM_FLIP_H
const ROT_BEND_3 := TileSetAtlasSource.TRANSFORM_TRANSPOSE | TileSetAtlasSource.TRANSFORM_FLIP_V


# Nettoie l'ecran
func clear() -> void:
	self.canvas1.clear()
	self.canvas2.clear()


# Dessine un serpent dans la grille
func draw_snake(chain: Array[Vector2i]) -> void:
	if chain.size() < 2:
		for coords in chain:
			self._draw_tile(coords, CROSS, 0)
	else:
		pass


# Dessine une pomme dans la grille
func draw_apple(coords: Vector2i) -> void:
	self._draw_tile(coords, APPLE, 0)


# Dessine une tile dans les deux tilemap
func _draw_tile(coords: Vector2i, tile: Vector2i, alternative: int) -> void:
	self.canvas1.set_cell(coords, 0, tile, alternative)
	self.canvas2.set_cell(coords, 0, tile, alternative)
