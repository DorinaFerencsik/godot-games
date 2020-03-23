extends KinematicBody2D

const ACCELERATION = 500
const MAX_SPEED = 100
const FRACTION = 500
const DIRECTIONS = ["Right", "Down", "Left", "Up"]
const ANIM_RUN_PREFIX = "Run"
const ANIM_IDLE_PREFIX = "Idle"

var velocity = Vector2.ZERO
var facing = Vector2()

onready var animationPlayer = $AnimationPlayer
onready var stateMachine = $AnimationTree.get("parameters/playback")


func _physics_process(delta):
	var input_vector = Vector2.ZERO
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	
	if LEFT || RIGHT || UP || DOWN:
		facing = input_vector
		
	var animation = direction2str(facing)
	var prefix
	if input_vector != Vector2.ZERO:
		prefix = ANIM_RUN_PREFIX
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta)
	else: 
		prefix = ANIM_IDLE_PREFIX
		velocity = velocity.move_toward(Vector2.ZERO, FRACTION * delta)

	if $AnimationPlayer.assigned_animation != animation:
			$AnimationPlayer.play(prefix + animation)
	
	velocity = move_and_slide(velocity)


func direction2str(direction):
	var angle = direction.angle()
	if angle < 0:
		angle += 2 * PI
	var index = round(angle / PI * 2)
	print(index)
	return DIRECTIONS[index]
