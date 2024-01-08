extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -500.0 #-500.0

const wall_jump_pushback = 1000

const wall_slide_gravity = 30 #980 #100
var is_wall_sliding = false


#fightvariables
var attack = false
var death = false
var health = 100

@onready var raycast = get_node("RayCast2D")
var platform_vol

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")

@onready var walk_sound = $WalkSound
@onready var jump_sound = $JumpSound
@onready var attack_sound = $AttackSound
@onready var get_hit_sound = $getHitSound
@onready var death_sound = $deathSound

signal player_death
var first_death_call = true

func _physics_process(delta):
	if death == false:
	
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta
			
		if Input.is_action_just_pressed("Attack"):
			attack_sound .play()
			executeAttack()
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and attack == false:
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_sound .play()
				anim.play("Jump")  
		
			if is_on_wall() and attack == false:
				var direction_is_left = get_node("AnimatedSprite2D").flip_h
				#left wall
				if direction_is_left and Input.is_action_pressed("ui_right"):
					velocity.y = JUMP_VELOCITY-150
					velocity.x = -wall_jump_pushback
					print("left wall")
				#right wall
				if not direction_is_left and Input.is_action_pressed("ui_left"):
					velocity.y = JUMP_VELOCITY-150
					velocity.x = wall_jump_pushback
					print("right wall")
	

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction == -1 and attack == false:
			get_node("AnimatedSprite2D").flip_h = true
			if $PlayerAttackArea/AttackShape2d.position.x > 0:
				$PlayerAttackArea/AttackShape2d.position.x *= -1
		elif direction == 1 and attack == false:
			get_node("AnimatedSprite2D").flip_h = false
			if $PlayerAttackArea/AttackShape2d.position.x < 0:
				$PlayerAttackArea/AttackShape2d.position.x *= -1
		if direction and attack == false:
			velocity.x = direction * SPEED
			if velocity.y == 0:
				anim.play("Run")
				if $walkSoundTimer.time_left <= 0:
					walk_sound.play()
					walk_sound.pitch_scale = randf_range(0.8, 1.2)
					$walkSoundTimer.start(0.25)		
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0 and attack == false:
				anim.play("Idle")
		if velocity.y > 0 and attack == false:
			anim.play("Fall")

		wall_slide(delta)
		move_and_slide()
	
	#on death
	else:
		if first_death_call:
			death_sound.play()
			anim.play("Dead")
			first_death_call = false
			emit_signal("player_death")
		
		
func _on_gameworld_player_revived():
	death = false
	health = 100	
	first_death_call = true


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
		#velocity.y = clamp(velocity.y, wall_slide_gravity, 50)

func executeAttack():
	attack = true
	anim.play("Attack")
	velocity.x = 0 
	await get_tree().create_timer(0.5).timeout
	attack = false
	
func hit(damage : int):
	if health > 0:
		health -= damage
		get_hit_sound.play()
		anim.play("Hurt")
		print(health)
	if health <= 0:
		death = true
		#anim.play("Dead")
		await get_tree().create_timer(0.3).timeout
		#self.queue_free()


func _on_player_attack_area_body_entered(_body):
	#The damage is calculated inside each enemy 
	#could be changed later for a capsulated damage System
	pass


func _on_take_damage_area_area_entered(area):
	if area.name == "PlayerHit":
		print("Skeleton hit")
		hit(10)
	if area.name == "PlayerAttackFish":
		print("Fish hit")
		hit(5)
	if area.name == "AttackArea":
		hit(15)
