extends Node2D

@onready var shadow_state = $"Shadow State"
@onready var chest_state = $"Chest State"

var is_open: bool

func _ready():
	is_open = true


func _on_player_interacting(body):
	if(body.has(self) and !is_open):
		var shadow_states: Array[Node] = shadow_state.get_children()
		var chest_states: Array[Node] = chest_state.get_children()
	
		for i in range(2):
			shadow_states[i].set_visible(!shadow_states[i].is_visible())
			chest_states[i].set_visible(!chest_states[i].is_visible())
		
		# Flag to keep from toggling chest open and closed
		is_open = true
