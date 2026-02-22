class_name GameBrick extends StaticBody2D


#region ATTRIBUTES

# Configuration des briques
@export
var config: GameBrickConfig

@onready
var sprite: Sprite2D = $Sprite

# Nombre de coups restants avant que cette brique disparaîsse
var hit_points: int = 1

#endregion


#region GODOT's METHODS

# Au démarrage, on récupère des infos à partir de la configuration
func _ready() -> void:
	# Sans configuration, la brique n'est pas utilisable
	if self.config == null:
		printerr("Missing brick configuration !")
		self.queue_free()
		return

	# On initialise le nombre de points de vie de la brique
	self.hit_points = self.config.hit_points

#endregion


#region CUSTOM METHODS

# Que faire lorsque la brique est touchée par la balle ?
func on_hit() -> void:
	# La brique perd un point de vie
	self.hit_points -= 1

	# Si le compteur atteint zero, la brique disparaît
	if self.hit_points <= 0:
		self.queue_free()

	# Sinon on change la couleur de la brique
	else:
		# on essaye d'obtenir un nouveau rendu pour la brique
		var render := self.config.get_render(self.hit_points - 1)
		if render == null:
			printerr("No render found")
			return

		# On applique le matériau à la brique
		sprite.material = render

#endregion
