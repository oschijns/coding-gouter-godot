class_name GameBrickConfig extends Resource

# Une resource permet de partager des données 
# de configuration entre plusieurs instances.


#region ATTRIBUTES

# Nombre de fois que la brique peut-être touchée avant d'être détruite
@export_range(1.0, 3.0, 1.0, "or_greater")
var hit_points: int = 1


# Séquence de couleur à afficher sur les briques 
# lorsqu'elles perdent des points de vie.
@export
var renders: Array[ShaderMaterial] = []

#endregion


#region CUSTOM METHODS

# Vérifie que la resource est correctement configurée
# Si c'est le cas, on renvoie "vrai", sinon on renvoie "faux"
func verify() -> bool:
	# Le nombre de points de vie doit être positif
	if self.hit_points <= 0:
		printerr("Hit points must be greater than zero !")
		return false
	# Nous devons avoir autant de configuration de rendu que de points de vie
	elif self.hit_points > self.renders.size():
		printerr("More hit points (%d) than render configurations (%d) defined !" % [self.hit_points, self.renders.size()])
		return false
	else:
		# Chaque configuration de rendu doit avoir une texture et un matériau associés
		var i := 0
		for render in self.renders:
			# On vérifie la présence d'une texture
			if render.texture == null:
				printerr("Missing texture on render resource at index %d" % i)
				return false
			# On vérifie la présence d'un matériau
			elif render.material == null:
				printerr("Missing material on render resource at index %d" % i)
				return false
			i += 1
		return true
	

# Obtient une paire de couleurs
func get_render(i: int) -> ShaderMaterial:
	if i < self.renders.size():
		return self.renders[i]
	else:
		printerr("Invalid render index %d" % i)
		return null

#endregion
