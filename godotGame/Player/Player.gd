extends KinematicBody2D
class_name Player
### BUG AREA: {X = fixed, O = open}
### [O] Editor bound jump force not affecting jump height.
### 	-> I suspect this is with the variable gravity implimentation, and will revisit that
###		-> everything else is working rn so not high priority at the moment.
### [X]  Double jump limiter breaking / Infinite Jumps:
### 	-> Was being caused in a couple of parts, one the coyote timer was not working as intended
### 	-> and also some of the other checks were overriding each other.
### 	-> I condensed the jump functions into one larger one (though kept a few elements abstracted,
### 	-> and was able to get the jump limiting workinbg correctly
###
### TODO AREA: {X = done, O = open, H = held, W = working}
### [X] Make gravity machine?
### 		-> pass GravityState.X where x = enum value into apply_gravity(delta, gravity_state)
### 		-> This will make it a LOT easier to add and change various gravity modifying effects in the future.

enum { MOVE, CLIMB }
enum GravityState {GRAVITY, FAST_FALL, SLAM, JUMP_RELEASE, NEUTRAL}

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres") as PlayerMovementData

#SLOPE FIX STUFF
const FLOOR_NORMAL = Vector2.UP
const SNAP_DIRECTION = Vector2.DOWN
const SNAP_LENGTH = 32.0
const snapping = SNAP_DIRECTION * SNAP_LENGTH
const not_snapping = Vector2(0, 0)

#Change to 0 to stop snap for jumps, then back for snaps
var snap_vector = snapping
##

var velocity = Vector2.ZERO
var state = MOVE
var gravity_state = GravityState.GRAVITY
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false
var jump_limiter = true
var was_on_ground = true

onready var animatedSprite: = $AnimatedSprite
onready var ladderCheck: = $LadderCheck
onready var jumpBufferTimer: = $JumpBufferTimer
onready var coyoteJumpTimer: = $CoyoteJumpTimer
onready var remoteTransform2D: = $RemoteTransform2D
onready var idleReset = $IdleReset


func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input, delta)
		CLIMB: climb_state(input)

func climb_state(input):
	if not is_on_ladder(): state = MOVE
	if input.length() != 0:
#		animatedSprite.animation = "Run"
		set_run()
	else:
#		animatedSprite.animation = "Idle"
		set_idle()
	velocity = input * moveData.CLIMB_SPEED
	velocity = move_and_slide(velocity, Vector2.UP)
func move_state(input, delta):
	#general stuff
	jump_handler(delta)
	slam(delta)
	#change state in state machine when implimented
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	#change to gravity machine implimentation?
	apply_gravity(delta, GravityState.GRAVITY)
	#horizontal movement and friction
	if not horizontal_move(input):
		apply_friction(delta)
		set_idle()
	else:
		apply_acceleration(input.x, delta)
		set_run()
		animatedSprite.flip_h = !input.x > 0
	#moves player
	velocity.y = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true).y
	#allow reseting horizontal momentum when changing direction
	player_brake()
	#checks
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var just_landed = is_on_floor() and was_in_air
	#set animation based on checks
	if just_landed and velocity.x != 0:
		set_run()
		animatedSprite.frame = 1
	elif just_landed and velocity.x == 0:
		set_idle()
func jump_handler(delta):
	#RESET JUMP
	if is_on_floor():
#		reset_double_jump()
		double_jump = moveData.DOUBLE_JUMP_COUNT
		was_on_ground = true
		jump_limiter = false
		#check buffer jump:
		if buffered_jump:
			buffered_jump = false
			jump()
	else:
		#sets sprite animation
		set_jump()
	#COYOTE
	if (Input.is_action_just_pressed("ui_up") and can_jump() and double_jump >= 0) or (Input.is_action_just_pressed("ui_up") and !coyoteJumpTimer.is_stopped() and double_jump >= 0):
		jump()
	else:
		input_jump_release(delta)
		if Input.is_action_just_pressed("ui_up") and double_jump >= 0:
			jump()
		pogo_jump()
		fast_fall(delta)
	buffered_jump = false
func set_idle():
	if is_on_floor():
		animatedSprite.animation = "Idle"
func set_jump():
	animatedSprite.animation = "Jump"
func set_run():
	if is_on_floor():
		animatedSprite.animation = "Run"
func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal("player_died")
func slam(delta):
	if Input.is_action_just_pressed("ui_down") and !is_on_floor():
		apply_gravity(delta, GravityState.SLAM)
func connect_camera(camera):
	print('connecting camera')
	var camera_path = camera.get_path()
	print(camera_path)
	remoteTransform2D.remote_path = camera_path
func player_brake():
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		velocity.x = 0
func jump():
#	door override
	if on_door: return
	snap_vector = not_snapping
	SoundPlayer.play_sound(SoundPlayer.JUMP)
	#may need to account for variable jump height below
	velocity.y = moveData.JUMP_FORCE
	double_jump -= 1
	yield(get_tree().create_timer(.01), 'timeout')
	snap_vector = snapping
func can_jump():
	var can_i_jump = false
	if is_on_floor(): can_i_jump = true
	if double_jump > 0: can_i_jump = true
	return can_i_jump
func pogo_jump():
	if (is_on_floor() and Input.is_action_pressed("ui_up") and can_jump()):
		jump()
##applies variable jump height
func input_jump_release(delta):
	if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
		apply_gravity(delta, GravityState.JUMP_RELEASE)
#for near ground jump input hits
func buffer_jump():
	if Input.is_action_just_pressed("ui_up") and not is_on_floor() and not jumpBufferTimer.is_stopped():
		buffered_jump = true
		jumpBufferTimer.start()
func fast_fall(delta):
	if !is_on_floor() and Input.is_action_pressed("ui_up"):
		apply_gravity(delta, GravityState.FAST_FALL)
func horizontal_move(input):
	return input.x != 0
func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true
func apply_gravity(delta, gravity_state):
		var internal_gravity_state = gravity_state
		match internal_gravity_state:
			GravityState.GRAVITY: 
				velocity.y += moveData.GRAVITY * delta
				velocity.y = min(velocity.y, 700)
			GravityState.FAST_FALL: 
				if velocity.y < 0:
					velocity.y += moveData.ADDITIONAL_FALL_GRAVITY * delta
			GravityState.SLAM: 
				velocity.y += moveData.GRAVITY * 5000 * delta
			GravityState.JUMP_RELEASE: 
				velocity.y = moveData.JUMP_RELEASE_FORCE
			GravityState.NEUTRAL:
				velocity.y = 0
func normal_gravity(delta):
	apply_gravity(delta, GravityState.GRAVITY)
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.FRICION * delta)
func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION * delta)
func _on_JumpBufferTimer_timeout():
	buffered_jump = false
func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
	jump_limiter = true
