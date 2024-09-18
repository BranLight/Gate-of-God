extends Node2D


func _ready():
	pass
	

func _process(_delta):
	var quit: bool = Input.is_action_pressed("QUIT")
	if(quit):
		get_tree().quit()
