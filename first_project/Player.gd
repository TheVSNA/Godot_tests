extends KinematicBody2D

export var MAX_SPEED = 300
export var ACCELERATION = 1500
export var FRICTION = 1200

onready var axis = Vector2.ZERO

var velocity = Vector2()

#delta is the time between 2 frames (1/60 of a second in this case)
func _physics_process(delta):
	#move_and_collide(velocity*delta)
	move(delta)
	

func get_input_axis():
	#is_action_pressed return true if the button corresponding to the action is pressed, false otherwise
	#actions are defined in progetto > impostazioni del progeto > mappa input
	axis.x= int(Input.is_action_pressed("move_right"))-int(Input.is_action_pressed("move_left"))
	axis.y= int(Input.is_action_pressed("move_down"))-int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	#if one of w,a,s,d buttons are pressed, calculate new values for velocity vectors, to allow player to move
	#otherwise apply frictions to current valocity to slow down and stop the movement
	if axis == Vector2.ZERO:
		apply_friction(FRICTION*delta)
	else:
		apply_movement(axis*ACCELERATION*delta)
		
	move_and_slide(velocity)
	
func apply_friction(amount):
	#velocity.length() seems to be the module (magnitude) of the vector
	if velocity.length() > amount:
		velocity-=velocity.normalized()*amount
	else:
		velocity = Vector2.ZERO

		
func apply_movement(acc):
	velocity+=acc
	velocity = velocity.limit_length(MAX_SPEED)
