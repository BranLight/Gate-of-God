extends Node2D

@export var notes_to_play : Array[int]
@onready var note_handler = $NoteHandler

var notes: Array[Node]
var curr_note: int = 0
var pause: int = 0

func _ready():
	notes = note_handler.get_children()
	$Timer.start()
	

func _process(_delta):
	pass
		
		
func _on_timer_timeout():
	if(curr_note == len(notes_to_play)):
		notes[notes_to_play[curr_note-1]].stop() 
		curr_note = 0
	if(curr_note > 0): notes[notes_to_play[curr_note-1]].stop()
	if(pause == len(notes_to_play)):
		pause = 0
		$Timer.stop()
		$Timer2.start()
	else:
		notes[notes_to_play[curr_note]].play()
		curr_note += 1
		pause += 1


func _on_timer_2_timeout():
	$Timer.start()
	$Timer2.stop()
