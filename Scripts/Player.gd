extends CharacterBody2D

const SPEED = 450.0
const JUMP_VELOCITY = -500.0
var attack = false
var death = false
var health = 100

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var anim = get_node("AnimationPlayer")


func _physics_process(delta):
	if death == false:
		# Add the gravity.
		if not is_on_floor():
			velocity.y += gravity * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor() and attack == false:
			velocity.y = JUMP_VELOCITY
			anim.play("Jump")
		
		if Input.is_action_pressed("Attack"):
			executeAttack()
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if attack == false:
			var direction = Input.get_axis("ui_left", "ui_right")
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
				if $PlayerAttackArea/AttackShape2D.position.x > 0:
					$PlayerAttackArea/AttackShape2D.position.x *= -1
			elif direction == 1:
				get_node("AnimatedSprite2D").flip_h = false
				if $PlayerAttackArea/AttackShape2D.position.x < 0:
					$PlayerAttackArea/AttackShape2D.position.x *= -1
			if direction:
				velocity.x = direction * SPEED
				if velocity.y == 0:
					anim.play("Run")
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
				if velocity.y == 0:
					anim.play("Idle")
			if velocity.y > 0:
				anim.play("Fall")

		move_and_slide()

func executeAttack():
	attack = true
	anim.play("Attack")
	await get_tree().create_timer(0.5).timeout
	attack = false
	
func hit(damage : int):
	health -= damage
	anim.play("Hurt")
	print(health)
	if health <= 0:
		death = true
		anim.play("Dead")
		await get_tree().create_timer(0.3).timeout
		self.queue_free()


func _on_area_2d_body_entered(body):
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
