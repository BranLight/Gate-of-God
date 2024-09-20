extends Node2D

signal level_up(level_song: String, portal: Node2D)

const SONGS = preload("res://Songs/songs.tres")

func _ready():
	pass

func _on_player_singing(body, note_queue):
	if(body.has(self)):
		for song in SONGS.portal_songs.values():
			var slice_val: int = len(note_queue)-len(song) if len(note_queue) > len(song) else 0
			if(note_queue.slice(slice_val) == song):
				level_up.emit(SONGS.portal_songs.find_key(song), self)
