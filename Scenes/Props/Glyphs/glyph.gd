@tool
extends Node2D

@export var rune_sprite: Sprite2D
@export var show_runes: bool :
	set(value):
		show_runes = value
		set_rune_visibility(show_runes)

func _ready():
	pass

func set_rune_visibility(value):
	if value:
		rune_sprite.show()
	else:
		rune_sprite.hide()


func _on_player_interacting(body):
	if(body.has(self)):
		set_rune_visibility(false)
		remove_from_group("interactable")
		
