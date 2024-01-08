extends CharacterBody2D
var health = 20
var SPEED = 5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var attacking = false
var damaged = false
var death = false
var anim

@onready var attack_sound = $attackSound
@onready var get_hit_sound = $getHitSound
@onready var death_sound = $deathSound

func _ready():
	anim = get_node("SkelettAnimationPlayer") 
	anim.play("Idle") #idle
	player = get_node("../Player")

func _physics_process(delta):
	velocity.y += gravity * delta
	
	#Decide Position and move
	if chase == true && attacking == false && damaged == false && death == false:
		anim.play("Walk") 
		var direction  = (player.position - self.position).normalized()
		if direction.x > 0:
			get_node("Sprite2D").flip_h = false
			if $PlayerHit/AttackShape2D.position.x < 0:
				$PlayerHit/AttackShape2D.position.x *= -1
				$PlayerAttack/CollisionShape2D.position.x *= -1
		else:
			get_node("Sprite2D").flip_h = true
			if $PlayerHit/AttackShape2D.position.x > 0:
				$PlayerHit/AttackShape2D.position.x *= -1
				$PlayerAttack/CollisionShape2D.position.x *= -1
		velocity.x += direction.x * SPEED

#Attack if enemy is in Range 
	if chase == true && attacking == true && damaged == false && death == false:
		
		if $attackSoundTimer.time_left <= 0:
			attack_sound.play()
			$attackSoundTimer.start(0.75)		
		
		anim.play("Attack")
		

#Play idle if no condition is met
	if chase == false && attacking == false && damaged == false && death == false:
		anim.play("Idle")
		velocity.x = 0
	
	if damaged == true:
		health = health - 5
		
		if death == false:
			anim.play("Hurt")
			get_hit_sound.play()
			damaged = false
		await get_tree().create_timer(0.3).timeout
		print(health)
		
		
		if health <= 0:
			death = true
			death_sound.play()
			velocity.x = 0
			anim.play("Death")
			await get_tree().create_timer(1.0).timeout
			self.queue_free()
	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		

func _on_player_attack_body_entered(body):
	if body.name == "Player":
		attacking = true;
		#anim.play("Attack")

func _on_player_attack_body_exited(_body):
	attacking = false
	
func _on_player_death_area_entered(area):
	if area.name == "PlayerAttackArea":
		damaged = true
