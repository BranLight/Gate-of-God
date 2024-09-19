extends CharacterBody2D

@export var speed: float = 100.0
@export var acceleration: float = 10.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var note_wheel: Control = $NoteWheel

var sprite_size: Vector2 = Vector2(32.0, 32.0)
var char_can_move: bool = true
var interactable_bodies: Array[Node2D]
var singable_bodies: Array[Node2D]


func movement_setup():
	char_can_move = !note_wheel.is_visible()
	if(char_can_move):
		movement()
	else:
		velocity = Vector2.ZERO
		anim.play("Idle")


func movement():
	var direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var sprinting: bool = Input.is_action_pressed("SPRINT")
	var sprint_scale: float = 2.0 if sprinting else 1.0
	
	velocity.x = move_toward(velocity.x, (speed * sprint_scale) * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, (speed * sprint_scale) * direction.y, acceleration)
	
	if(velocity.length() <= acceleration):
		anim.play("Idle")
	else:
		if(Input.is_action_pressed("DOWN")):
			anim.play("Walk Forward", sprint_scale)
		elif(Input.is_action_pressed("UP")):
			anim.play("Walk Backward", sprint_scale)
		elif(Input.is_action_pressed("RIGHT")):
			anim.flip_h = false
			anim.play("Walk Side", sprint_scale)
		elif(Input.is_action_pressed("LEFT")):
			anim.flip_h = true
			anim.play("Walk Side", sprint_scale)
			

func note_wheel_control():
	if(Input.is_action_just_pressed("NOTEWHEEL")):
		note_wheel.set_visible(!note_wheel.is_visible())
	
		
func check_interaction():
	if(Input.is_action_just_pressed("INTERACT")):
		for i in range(len(interactable_bodies)):
			interactable_bodies[i].player_interacting()
		

func _ready():
	note_wheel.set_scale(Vector2(0.25, 0.25))
	note_wheel.position.y += -sprite_size.y/2.0
	

func _physics_process(_delta):
	note_wheel_control()
	check_interaction()
	movement_setup()
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D):
	if(body.is_in_group("interactable")):
		interactable_bodies.append(body.get_parent())
	if(body.is_in_group("singable")):
		singable_bodies.append(body.get_parent())
		

func _on_area_2d_body_exited(body: Node2D):
	if(body.is_in_group("interactable")):
		var pop_index: int = interactable_bodies.find(body.get_parent())
		interactable_bodies.pop_at(pop_index)
	if(body.is_in_group("singable")):
		var pop_index: int = singable_bodies.find(body.get_parent())
		singable_bodies.pop_at(pop_index)
