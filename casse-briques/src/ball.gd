class_name GameBall extends CharacterBody2D


#region ATTRIBUTES

# Signal émit lorsque la balle rebondi
signal ball_bounce

#endregion


#region GODOT's METHODS

func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	pass

#endregion


#region CUSTOM METHODS

# Stop la balle
func reset() -> void:
	pass


# Lance la balle
func launch(dir: Vector2) -> void:
	pass

#endregion
