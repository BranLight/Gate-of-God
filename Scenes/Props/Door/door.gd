extends Node2D

@onready var door_state = $"Door State"
@onready var static_body_2d = $StaticBody2D


func _ready():
	pass
	

func _on_player_interacting(body):
	if(body.has(self)):
		var layer_one: int = static_body_2d.get_collision_layer_value(1)
		var layer_two: int = static_body_2d.get_collision_layer_value(2)
		
		static_body_2d.set_collision_layer_value(1, !layer_one)
		static_body_2d.set_collision_layer_value(2, !layer_two)
		
		var door_states: Array[Node] = door_state.get_children()
		
		for i in range(2):
			door_states[i].set_visible(!door_states[i].is_visible())
