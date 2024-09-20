extends CharacterBody2D

signal interacting(body: Array[Node2D])
signal singing(body: Array[Node2D], note_queue: Array[int])
signal player_is_singing(singing: bool)

@export var speed: float = 100.0
@export var acceleration: float = 15.0

@onready var animation_player = $AnimationPlayer
@onready var note_wheel: Control = $NoteWheel
@onready var footsteps = $Footsteps

var sprite_size: Vector2 = Vector2(32.0, 32.0)
var char_can_move: bool = true
var can_send_note_queue: bool = false

# For sending signals
var interactable_bodies: Array[Node2D]
var singable_bodies: Array[Node2D]


func movement_setup():
	char_can_move = !note_wheel.is_visible()
	if(char_can_move):
		movement()
	else:
		velocity = Vector2.ZERO
		animation_player.play("Idle")


func movement():
	var direction: Vector2 = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN")
	var sprinting: bool = Input.is_action_pressed("SPRINT")
	var sprint_scale: float = 2.0 if (sprinting and velocity != Vector2.ZERO) else 1.0
	animation_player.set_speed_scale(sprint_scale)
	
	velocity.x = move_toward(velocity.x, speed * sprint_scale * direction.x, acceleration)
	velocity.y = move_toward(velocity.y, speed * sprint_scale * direction.y, acceleration)
	
	var moving_down: bool = velocity.y > 0.0
	var moving_up: bool = velocity.y < 0.0
	var moving_right: bool = velocity.x > 0.0
	var moving_left: bool = velocity.x < 0.0
	
	if(velocity == Vector2.ZERO):
		animation_player.play("Idle")
	else:
		if(Input.is_action_pressed("DOWN") and moving_down):
			animation_player.play("Walk_Forward")
		elif(Input.is_action_pressed("UP") and moving_up):
			animation_player.play("Walk_Backwards")
		elif(Input.is_action_pressed("RIGHT") and moving_right):
			animation_player.play("Walk_Right")
		elif(Input.is_action_pressed("LEFT") and moving_left):
			animation_player.play("Walk_Left")
			

func note_wheel_control():
	if(Input.is_action_just_pressed("NOTEWHEEL")):
		note_wheel.set_visible(!note_wheel.is_visible())
		if(note_wheel.is_visible()):
			player_is_singing.emit(true)
		else:
			player_is_singing.emit(false)
	
		
func check_interaction():
	if(Input.is_action_just_pressed("INTERACT")):
		for i in range(len(interactable_bodies)):
			interacting.emit(interactable_bodies)
			
			
func check_singing():
	if(Input.is_action_pressed("SING") and can_send_note_queue):
		for i in range(len(singable_bodies)):
			singing.emit(singable_bodies, note_wheel.note_queue)
		can_send_note_queue = false
		
		
func play_footstep():
	var footstep_sounds: Array[Node] = footsteps.get_children()
	for sound in footstep_sounds:
		if(sound.is_playing()):
			sound.stop()
	footstep_sounds.pick_random().play()
	
func _ready():
	note_wheel.set_scale(Vector2(0.25, 0.25))
	note_wheel.position.y += -sprite_size.y/2.0
	

func _physics_process(_delta):
	note_wheel_control()
	check_interaction()
	check_singing()
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


func _note_queue_has_updated():
	can_send_note_queue = true
