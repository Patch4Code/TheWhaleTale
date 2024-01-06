extends CharacterBody2D
#Variables that the Caracter uses
var HEALTH = 60
var SPEED = 10
#State variables used to lock animations and actions
var damaged = false
var death = false
var chase = false
var attack = false
var recharge = false
var hurting = false
var attackcounter = 0
#global varaiables:
var anim # contains the Animationsplayer#
var player 
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction
#Setup of the Boss
func _ready():
		anim = get_node("AnimationPlayer")
		anim.play("Idle")
		player = get_node("../Player")

func _physics_process(delta):
	#Player falls down with gravity
	velocity.y += gravity * delta
	if death == false:
		#Decide Position:
		if recharge == false:
			direction = (player.position - self.position).normalized()
			#Flip the Sprite
			if direction.x > 0:
				get_node("PirateSprite").flip_h = false
				if $AttackArea/SwordHitBox.position.x < 0:
					$AttackArea/SwordHitBox.position.x *= -1
					$PlayerInAttackRange/AreaForAttack.position.x *= -1
			else:
				get_node("PirateSprite").flip_h = true
				if $AttackArea/SwordHitBox.position.x > 0:
					$AttackArea/SwordHitBox.position.x *= -1
					$PlayerInAttackRange/AreaForAttack.position.x *= -1
			
		#Walk towards player if detected
		if chase == true and recharge == false and attack == false and damaged == false:
			#execute Walking movement
			velocity.x += direction.x * SPEED
			anim.play("Run")
		
		#creates Timeout after each attack
		if recharge == true:
			attack = false
			anim.play("Idle")
			await get_tree().create_timer(0.5).timeout
			recharge = false
			chase = true
		
		if attack == true and recharge == false and damaged == false:
			if attackcounter <= 2:
				WeakAttack()
			else:
				StrongAttack()
			
			if attackcounter >= 4:
				attackcounter = 0
		
		if damaged == true:
			Damaged()
			print(HEALTH)
		
		if hurting == true :
			hurtAnim()
		
		if HEALTH <= 0:
			Die()
			
		move_and_slide()
		
		
#----------------Functions Used in the Boss
#Heavy attack deals more Damage but is slow:
func StrongAttack():
	attack = true
	chase = false
	velocity.x = 0
	anim.play("Attack_1")
	await get_tree().create_timer(1.0).timeout 
	recharge = true
	
#fast but weaker attack
func WeakAttack():
	attack = true
	chase = false
	velocity.x = 0
	anim.play("Attack_2")
	await get_tree().create_timer(0.7).timeout #timeout to prevent spam
	recharge = true

#Character dies, death is used to lock other actions 
#state death is final and ends "Statemachine"
func Die():
	death = true
	anim.play("Death")
	await get_tree().create_timer(1.0).timeout
	self.queue_free()

#chatacter recieved damage Lock other animations 
func Damaged():
	damaged = true
	hurting = true
	HEALTH -= 10
	damaged = false
	
	
func hurtAnim():
	#if HEALTH >= 0:
	anim.play("Hurt")
	await get_tree().create_timer(1.0).timeout
	hurting = false
	
	
#-------------------------------------- Colissions with certain areas:

#Player entered line of sight
func _on_player_detected_body_entered(body):
	if body.name == "Player":
		chase = true

#Player exiteded line of sight
func _on_player_detected_body_exited(body):
	if body.name == "Player":
		chase = false


#Player entered attack zone
func _on_player_in_attack_range_body_entered(body):
	if body.name == "Player":
		attackcounter += 1
		#print(attackcounter)
		attack = true
		
#player exited attack zone 
func _on_player_in_attack_range_body_exited(body):
	if body.name == "Player":
		attack = false

#player hit Pirate boss
func _on_damageble_area_area_entered(area):
	if area.name == "PlayerAttackArea":
		damaged = true
