class_name GamePaddle extends AnimatableBody2D

#region ATTRIBUTES

# var...

#endregion


#region GODOT's METHODS

func _ready() -> void:
	pass

# Quand le joueur appuie sur la touche "ESC" on veut quitter le jeu
func _input(event: InputEvent) -> void:
	if event.is_action("game_quit"):
		get_tree().quit()

# Détecte si la souris est dans la fenêtre de jeu ou non
func _notification(what: int) -> void:
	pass

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

#endregion
