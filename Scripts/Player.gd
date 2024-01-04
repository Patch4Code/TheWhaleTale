extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -500.0
const jump_power = -1800.0

const acc = 50
const friction = 70

const wall_jump_pushback = 100

const wall_slide_gravity = 100
var is_wall_sliding = false

var octootto_in_range = false

var in_chest_dec = false

@onready var raycast = get_node("RayCast2D")
var platform_vol

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#var gravity = 120

@onready var anim = get_node("AnimationPlayer")

@onready var walk_sound = $WalkSound

func _physics_process(delta):
	
	if in_chest_dec == true:
		if Input.is_action_just_pressed("ui_down"):
			global.found_octootto_item = true
	
	if octootto_in_range == true:
		if Input.is_action_just_pressed("ui_up"):
			DialogueManager.show_example_dialogue_balloon(load("res://main.dialogue"), "main")
			return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == -1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
			if $walkSoundTimer.time_left <= 0:
				walk_sound.play()
				walk_sound.pitch_scale = randf_range(0.8, 1.2)
				$walkSoundTimer.start(0.25)		
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	if velocity.y > 0:
		anim.play("Fall")

	move_and_slide()
	jump()
	wall_slide(delta)


func _on_detection_area_body_entered(body):
	if body.has_method("enemy"):
		octootto_in_range = true


func _on_detection_area_body_exited(body):
	if body.has_method("enemy"):
		octootto_in_range = false


func player():
	pass

func _on_chestdetection_body_entered(body):
	if body.has_method("player"):
		in_chest_dec = true


func _on_chestdetection_body_exited(body):
	if body.has_method("player"):
		in_chest_dec = false


func jump():
	#velocity.y += gravity
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_power
		if is_on_wall() and Input.is_action_pressed("ui_right"):
			velocity.y = jump_power
			velocity.x = -wall_jump_pushback
		if is_on_wall() and Input.is_action_pressed("ui_left"):
			velocity.y = jump_power
			velocity.x = wall_jump_pushback


func wall_slide(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_wall_sliding = true
		else:
			is_wall_sliding = false
	else:
		is_wall_sliding = false
	
	if is_wall_sliding:
		velocity.y += (wall_slide_gravity * delta)
		velocity.y = min(velocity.y, wall_slide_gravity)
