#makes it work on character node
extends KinematicBody2D

# 'export(type)' allows you to adjust values in editor
export(int) var JUMP_FORCE = -130
export(int) var JUMP_RELEASE_FORCE = -35
export(int) var MAX_SPEED = 50
export(int) var ACCELERATION = 10
export(int) var FRICTION = 10
export(int) var GRAVITY = 4
export(int) var ADDITIONAL_FALL_GRAVITY = 4
export(bool) var STOP_ON_SLOPE_TOGGLE = true

#velocity vector, has velocity.x and velocity.y
var velocity : Vector2 = Vector2.ZERO
var jumps_available = 2

#binding like dom binding
onready var animatedSprite = $AnimatedSprite

#anything that needs to run on start goes in here
func _ready():
	pass
	
#default fps is 60fps, so delta is 1/60th; underscore before param just means it
#won't throw a concern when it might not be, or isn't, used.
func _physics_process(_delta):
	apply_gravity()
	
	#zero vector
	var input = Vector2.ZERO
	
	#get_actionStrength makes it work with controllers
	input.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	if input.x == 0:
		apply_friction()
		animatedSprite.animation = "Idle"
	else:
		apply_acceleration(input.x)
		animatedSprite.animation = "Run"
		#$AnimatedSprite.flip_h = true
	if Input.is_action_just_pressed("ui_left") or\
	 Input.is_action_just_pressed("ui_right"):
		velocity.x = 0
	if Input.is_action_just_pressed("ui_up") and jumps_available > 0:
		velocity.y = JUMP_FORCE
		jumps_available -= 1
		print(jumps_available)
		print(is_on_floor())
	#weirdness to get pseudo coyote time jump working
	elif Input.is_action_just_pressed('ui_up') and is_on_floor() and\
 jumps_available > 0:
		velocity.y = JUMP_FORCE
		jumps_available -= 2
		print(jumps_available)
		print(is_on_floor())
		
	#Premium Jump Enhancements
	if Input.is_action_just_released("ui_up") and velocity.y < JUMP_RELEASE_FORCE:
		velocity.y = JUMP_RELEASE_FORCE
		if velocity.y > 5:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	#a really dumb way to know when to display jump animation.
	if !is_on_floor(): 
		animatedSprite.animation = "Jump"
	#resets jumps by being on the floor (and accounts for is_on_floor() counting
	if is_on_floor() and velocity.y >= 0:
		jumps_available = 2
		
	# '\' just seperates line into readable code
	##checks for input and if on a floor to stop momentum
	if is_on_floor() and !Input.is_action_pressed("ui_up")\
	and !Input.is_action_pressed("ui_down")\
	and !Input.is_action_pressed("ui_left")\
	and !Input.is_action_pressed("ui_right"):
		velocity.x = 0

	#some stuff for checking if was just in the air
	var was_in_air = !is_on_floor()
	#move_and_slide handles the movement, parameters passed in are\
	#velocity, gravity direction, and a bool for if you should slide\
	#on slopes or not.
	velocity = move_and_slide(velocity, Vector2.UP, STOP_ON_SLOPE_TOGGLE)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		animatedSprite.animation = "Run"
		#animatedSprite.frame = 1
		
#You're not gonna believe what this applies.
func apply_gravity():
		velocity.y += GRAVITY
		velocity.y = min(velocity.y, 300)

#This too.
func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

#Gotta go fast!
func apply_acceleration(amount):
	if velocity.x > 0:
		#flip sprite direction
		animatedSprite.flip_h = false
	else:
		#flip sprite direction
		animatedSprite.flip_h = true
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
