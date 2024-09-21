extends Node2D

var audio_children: Array[Node]
var volume_tween: Tween

func _ready():
	audio_children = get_children()
	

# If the player is singing we don't want other audio playing
func _on_player_is_singing(singing):
	if(volume_tween): volume_tween.kill()
	for child in audio_children:
		volume_tween = get_tree().create_tween().bind_node(child)
		if(singing):
			volume_tween.tween_property(child, "volume_db", -80.0, 3.0)
			await volume_tween.finished
			child.stop()
		else:
			child.play()
			volume_tween.tween_property(child, "volume_db", 0.0, 2.0)
