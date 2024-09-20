extends Node2D

@onready var portal_1 = $Portals/Portal
@onready var portal_2 = $Portals/Portal2
@onready var portal_3 = $Portals/Portal3
@onready var portal_4 = $Portals/Portal4
@onready var player = $Player

func _ready():
	pass


func _process(_delta):
	var quit: bool = Input.is_action_pressed("QUIT")
	if(quit):
		get_tree().quit()


func _on_portal_level_up(level_song, portal):
	if(level_song == "Level One" and portal == portal_1):
		player.position = portal_2.position
	elif(level_song == "Level Two" and portal == portal_2):
		player.position = portal_3.position
	elif(level_song == "Level Three" and portal == portal_3):
		player.position = portal_4.position
