@tool
extends Node2D

@export_group("Grass Atlas Sprite Choice")
@export_range(0, 3, 1.0) var grass_choice_x: float :
	set(value):
		grass_choice_x = value
		# grass_tex won't be initialized until _ready called
		if(grass_tex):
			update_grass_tex()
@export_range(0, 3, 1.0) var grass_choice_y: float :
	set(value):
		grass_choice_y = value
		# grass_tex won't be initialized until _ready called
		if(grass_tex):
			update_grass_tex()

var grass_choice: Vector2

@onready var grass_tex = $GrassTex

const GRASSES = preload("res://Textures/Tile Sheets/grasses.tres")
const SPRITE_SIZE = Vector2(32.0, 32.0)

func update_grass_tex():
	grass_choice = Vector2(grass_choice_x, grass_choice_y)
	grass_tex.region_enabled = true
	grass_tex.set_region_rect(Rect2(SPRITE_SIZE * grass_choice, SPRITE_SIZE))

func _ready():
	update_grass_tex()
