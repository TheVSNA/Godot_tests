extends CharacterBody2D


@export var MAX_SPEED = 300
@export var ACCELERATION = 1500
@export var FRICTION = 1200

@onready var axis = Vector2.ZERO

const GRAVITY = 50

func _physics_process(delta):
	move(delta)
	

func get_input_axis():
	axis.x= int(Input.is_action_pressed("move_right"))-int(Input.is_action_pressed("move_left"))
	axis.y= int(Input.is_action_pressed("move_down"))-int(Input.is_action_pressed("move_up"))
	return axis.normalized()

func move(delta):
	axis = get_input_axis()
	#todo apply friction only on the ground?
	apply_friction(FRICTION*delta)
	apply_movement(axis*ACCELERATION*delta,axis)
		
	
	move_and_slide()
	
func apply_friction(amount):
	if velocity.x > amount || velocity.x<-amount:
		if(velocity.x<0):
			velocity.x+=amount
		elif(velocity.x>0):
			velocity.x-=amount
	else:
		velocity.x=0


var jump=false
var going_up=false
var going_down=false
func apply_movement(acc,axis):
	if(axis.x<0):
		velocity.x=-300
	elif(axis.x>0):
		velocity.x=300
	else:
		velocity.x=0
	#nb missing terminal velocity on fall
	if(axis.y<0 && !going_up && !going_down):#start jump, going up
		going_up=true
		velocity.y=-1500
	elif(axis.y==0 && going_up):
		going_up=false
		going_down=true
		velocity.y=GRAVITY
	elif(going_up && velocity.y<0):#going up,apply gravity 
		velocity.y+=GRAVITY
	elif(going_up && velocity.y<=0):#apogee, apply gravity, start going down
		going_up=false
		going_down=true
		velocity.y+=GRAVITY
	elif(going_down && velocity.y>0):	#going down keep applying gravity
		velocity.y+=GRAVITY
	elif(going_down && velocity.y==0):	#end jump
		going_up=false
		going_down=false
	
