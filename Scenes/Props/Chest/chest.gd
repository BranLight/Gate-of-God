extends Node2D

@onready var shadow_state = $"Shadow State"
@onready var chest_state = $"Chest State"


func _ready():
	pass
	

func player_interacting():
	var shadow_states: Array[Node] = shadow_state.get_children()
	var chest_states: Array[Node] = chest_state.get_children()
	
	for i in range(2):
		shadow_states[i].set_visible(!shadow_states[i].is_visible())
		chest_states[i].set_visible(!chest_states[i].is_visible())
