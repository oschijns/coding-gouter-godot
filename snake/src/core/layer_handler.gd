@tool
class_name LayerHandler extends Node


"""
	Script utilitaire qui permet de gérer les différentes couches de tilemap
	ainsi que l'effet d'ombre de l'écran LCD.
"""


#region PROPERTIES

# Liste des calques du premier plan
@export
var foreground_layers: Array[TileMapLayer] = []

# Calque de l'arrière plan à faire diverger
@export
var background_layer: TileMapLayer = null

# Angle de divergence entre les calques
@export_range(0.0, 360.0)
var divergence_angle := 0.0:
	set(value):
		divergence_angle = value
		_diverge_layers()

# Taux de divergence entre les calques
@export_range(0.0, 2.0, 0.1, "or_greater")
var divergence_offset := 0.0:
	set(value):
		divergence_offset = value
		_diverge_layers()

# Taille des calques
@export
var layers_scale := Vector2.ONE:
	set(value):
		layers_scale = value
		for layer in foreground_layers:
			layer.scale = value
		if background_layer:
			background_layer.scale = value


#endregion


#region PUBLIC METHODS

# Nettoie une tuile dans le tilemap
func clear_tile(coords: Vector2i) -> void:
	# Nettoie la cellule si il y avait une autre tuile auparavant
	for layer in foreground_layers:
		layer.set_cell(coords)
	if background_layer:
		background_layer.set_cell(coords)


# Dessine une tuile dans les tilemaps
func draw_tile(coords: Vector2i, tile: Vector2i, alternative: int = 0, color: int = 0) -> void:
	# Nettoie la cellule si il y avait une autre tuile auparavant
	for layer in foreground_layers:
		layer.set_cell(coords)

	# Dessine la nouvelle tuile dans un layer foreground
	if not foreground_layers.is_empty():
		var i := color % foreground_layers.size()
		foreground_layers[i].set_cell(coords, 0, tile, alternative)

	# Dessine la nouvelle tuile dans le layer background
	if background_layer:
		background_layer.set_cell(coords, 0, tile, alternative)


# Nettoie l'écran
func clear() -> void:
	for layer in foreground_layers:
		layer.clear()
	if background_layer:
		background_layer.clear()

#endregion


#region PRIVATE METHODS

# Applique un offset au layer d'arrière plan qui sert d'effet d'ombre
func _diverge_layers() -> void:
	if background_layer:
		var direction := Vector2.from_angle(deg_to_rad(divergence_angle))
		background_layer.transform.origin = direction * divergence_offset

#endregion
