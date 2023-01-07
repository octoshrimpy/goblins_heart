extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity = Vector2.ZERO
var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false
var on_door = false

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

func move_state(input, delta):
	slam(delta)
	if is_on_floor() and Input.is_action_pressed("ui_up") and can_jump():
		pogo_jump()
		
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	
	#change to gravity machine implimentation
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
#		if not idleReset.is_stopped():
#		animatedSprite.animation = "Idle"
		set_idle()
	else:
		apply_acceleration(input.x, delta)
#		animatedSprite.animation = "Run"
		set_run()
		animatedSprite.flip_h = !input.x > 0
	
	if is_on_floor():
		
		reset_double_jump()
	else:
#		animatedSprite.animation = "Jump"
		set_jump()
		
	
	if can_jump():
		input_jump()
	else:
		input_jump_release()
		input_double_jump()
		buffer_jump()
		pogo_jump()
		fast_fall(delta)

	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
#	if was_in_air and is_on_floor() and velocity.x <= 0:
#		set_idle()
	
	velocity = move_and_slide(velocity, Vector2.UP, true)
	
	player_brake()
	
	
	var just_landed = is_on_floor() and was_in_air
	if just_landed and velocity.x != 0:
#		print('animation frame over ride')
		set_run()
#		animatedSprite.animation = "Run"
		animatedSprite.frame = 1
	elif just_landed and velocity.x == 0:
		set_idle()
	
	var just_left_ground = not is_on_floor() and was_on_floor
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()

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

func set_idle():
	if is_on_floor():
		animatedSprite.animation = "Idle"
func set_jump():
#	yield(get_tree().create_timer(0.01), "timeout")
	animatedSprite.animation = "Jump"
func set_run():
	if is_on_floor():
		animatedSprite.animation = "Run"
func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal("player_died")

#not yet working: for some reason the fall gravity is not applying even
#at absurd numbers.
func slam(delta):
	if Input.is_action_just_pressed("ui_down") and !is_on_floor():
		velocity.y += moveData.GRAVITY * 50000 * delta
func connect_camera(camera):
	print('connecting camera')
	var camera_path = camera.get_path()
	print(camera_path)
	remoteTransform2D.remote_path = camera_path
func player_brake():
	if Input.is_action_just_released("ui_left") or Input.is_action_just_released("ui_right"):
		velocity.x = 0
func pogo_jump():
	if is_on_floor() and Input.is_action_pressed("ui_up") and can_jump():
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1
func input_jump_release():
	if Input.is_action_just_released("ui_up") and velocity.y < moveData.JUMP_RELEASE_FORCE:
		velocity.y = moveData.JUMP_RELEASE_FORCE

func input_double_jump():
	if Input.is_action_just_pressed("ui_up") and double_jump > 0:
		buffered_jump = false
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		double_jump -= 1

func buffer_jump():
	if Input.is_action_just_pressed("ui_up") and not is_on_floor() and not jumpBufferTimer.is_stopped():
		buffered_jump = true
		jumpBufferTimer.start()

func fast_fall(delta):
	if velocity.y > 0:
		velocity.y += moveData.ADDITIONAL_FALL_GRAVITY * delta

func can_jump():
	return is_on_floor() or coyote_jump

func horizontal_move(input):
	return input.x != 0

func reset_double_jump():
	double_jump = moveData.DOUBLE_JUMP_COUNT

func input_jump():
	if on_door: return
	if Input.is_action_just_pressed("ui_up") or buffered_jump:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.JUMP_FORCE
		buffered_jump = false

func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func apply_gravity(delta):
	velocity.y += moveData.GRAVITY * delta
	velocity.y = min(velocity.y, 700)

func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.FRICION * delta)

func apply_acceleration(amount, delta):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * amount, moveData.ACCELERATION * delta)

func _on_JumpBufferTimer_timeout():
	buffered_jump = false

func _on_CoyoteJumpTimer_timeout():
	coyote_jump = false
