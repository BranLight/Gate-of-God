extends Camera2D

@export var lerp_speed: float = 2.0
@export var cam_distance: float = 50.0
@export var my_player: Node

# Moves the camera smoothly a bit ahead of the player's movement
func _physics_process(delta):
	offset = offset.lerp(my_player.velocity.normalized() * cam_distance, delta * lerp_speed)
