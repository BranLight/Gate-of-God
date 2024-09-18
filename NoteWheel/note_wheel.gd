extends Control

@export var icon_radius: float = 200.0
@export var cursor_radius: float = 5.0
@export var notes: Array[Notes]

@onready var note_sounds = $NoteSounds

const SPRITE_SIZE: Vector2 = Vector2(40.0, 40.0)
const CURSOR_COLOR: Color = Color.WHITE
const NOTE_COLOR: Color = Color.AQUA
const NOTE_HIGHLIGHT: Color = Color.GOLD

var note_color: Color
var near_threshold: float = 75.0

func play_note(note_index: int, can_play: bool):
	if(Input.is_action_just_pressed("SING") and can_play):
		note_sounds.get_child(note_index).play()
	elif(Input.is_action_just_released("SING")):
		note_sounds.get_child(note_index).stop()


func _draw():
	var offset: Vector2 = SPRITE_SIZE / -2
	
	# Cursor circle and movement
	var direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var dir_mod: Vector2 = direction * icon_radius
	draw_circle(dir_mod * .75, cursor_radius, CURSOR_COLOR)
	
	for i in range(8):
		var pos: Vector2 = Vector2.from_angle(deg_to_rad(45 * i))
		var pos_mod: Vector2 = pos * icon_radius
		
		if(dir_mod.distance_to(pos_mod) > near_threshold):
			note_color = NOTE_COLOR
			play_note(i, false)
		else:
			note_color = NOTE_HIGHLIGHT
			play_note(i, true)
		
		draw_texture_rect_region(
			notes[i].atlas,
			Rect2(pos_mod + offset, SPRITE_SIZE),
			notes[i].region,
			note_color
		)
	

func _physics_process(_delta):
	queue_redraw()
