@tool
class_name ShadowEffect extends Node


"""
	Script utilitaire qui permet de gérer l'effet d'ombre de l'écran LCD.
"""


#region PROPERTIES

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
		for layer in canvas_layers:
			layer.scale = value


# Liste des calques à faire diverger
@export
var canvas_layers: Array[TileMapLayer] = []

#endregion


#region PRIVATE METHODS

func _diverge_layers() -> void:
	# On éjecte les cas tordus qui nous embêtent
	var count := canvas_layers.size()
	if count > 1:
		# On détermine la distance entre chaque calque et la direction à appliquer
		var padding   := divergence_offset / (count - 1) as float
		var direction := Vector2.from_angle(deg_to_rad(divergence_angle))

		# On applique une translation à chaque calque sauf le premier
		for i in range(1, count):
			var layer := canvas_layers[i]
			layer.transform.origin = direction * (padding * i as float)

#endregion
