extends KinematicBody2D

export (int) var speed = 120
export (int) var jump_speed = -180
export (int) var gravity = 400
export (int) var slide_speed = 400

var veloctiy = Vector2.ZERO
	
export (float) var friction = 10
export (float) var acceleration = 25

enum state {IDLE, RUNNING, PUSHING, ROLLING, JUMP, STARTJUMP, FALL, ATTACK}
	
onready var player_state = state.IDLE

func _ready():
	$AnimationPlayer.play("idle")
	pass

func update_anmation(anim):
	 $AnimationPlayer.play(anim)
	
func handle_state(state):
	pass
	
func get_input():
	var dir = Input.get_action_strength("right") - Input.get_action_strength("left")
	if dir != 0:
		veloctiy.x = move_toward(veloctiy.x, dir*speed, acceleration)
	else:
		veloctiy.x = move_toward(veloctiy.x, 0, friction)
		
func _physics_process(delta):
	get_input()
	if veloctiy.x == Vector2.ZERO:
		player_state = state.IDLE
	elif veloctiy.x != 0 and Input.is_action_just_pressed("jump") and is_on_floor():
		player_state = state.STARTJUMP
	elif veloctiy.x != 0:
		player_state = state.RUNNING
	
	if not is_on_floor():
		if veloctiy.y < 0:
			state.JUMP
		if veloctiy.y > 0:
			player_state = state.FALL
