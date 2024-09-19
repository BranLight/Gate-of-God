extends Control

signal note_queue_has_updated

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

var note_queue: Array[int]
var note_queue_size: int = 8

func play_note(note_index: int, is_near: bool):
	var note: AudioStreamPlayer = note_sounds.get_child(note_index)
	var singing: bool = Input.is_action_pressed("SING")
	if(singing and is_near and !note.is_playing()):
		note.play()
		
		# Add notes to queue limited to queue size
		note_queue.push_back(note_index)
		if(len(note_queue) > note_queue_size):
			note_queue.pop_front()
		note_queue_has_updated.emit()
			
	elif(!singing or !is_near):
		note.stop()


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
	if(!note_queue.is_empty() and !is_visible()): note_queue.clear()
	queue_redraw()
