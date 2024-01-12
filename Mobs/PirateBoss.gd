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

var insideAttack = false

signal disable_fogwall
signal drop_treasure

@onready var attack_sound_fast = $attakSoundFast
@onready var attack_sound_heavy = $attackSoundHeavy
@onready var get_hit_sound = $getHitSound
@onready var death_sound = $deathSound
@onready var arr_sound = $arrSound
@onready var landlubber_sound = $landlubberSound
var pirate_already_greeted = false

var spawn_position
var player_dead = false

#Setup of the Boss
func _ready():
		anim = get_node("AnimationPlayer")
		anim.play("Idle")
		player = get_node("../Player")
		
		spawn_position = self.global_position

func _physics_process(delta):
	#Player falls down with gravity
	velocity.y += gravity * delta
	if death == false and not player_dead:
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
			if pirate_already_greeted == false:
				landlubber_sound.play()
				pirate_already_greeted = true
		
		#creates Timeout after each attack
		if recharge == true:
			attack = false
			arr_sound.play()
			anim.play("Idle")
			await get_tree().create_timer(0.7).timeout
			recharge = false
			#pirate should continue attack if player is still there
			if insideAttack == true:
				chase = false
				attack = true
			else:
				attack = false
				chase = true
				print("recharge chase-true")
				

			
		if attack == true and recharge == false and damaged == false:
			fighting()
		
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
	attack_sound_heavy.play()
	attack = true
	chase = false
	velocity.x = 0
	anim.play("Attack_1")
	await get_tree().create_timer(1.0).timeout 
	attack = true
	recharge = true
	
#fast but weaker attack
func WeakAttack():
	attack_sound_fast.play()
	attack = true
	chase = false
	velocity.x = 0
	anim.play("Attack_2")
	await get_tree().create_timer(0.7).timeout #timeout to prevent spam
	recharge = true

#mixes strong and weak attacks
func fighting():
	if attackcounter <= 2:
		WeakAttack()
	else:
		StrongAttack()
	if attackcounter >= 4:
		attackcounter = 0

#Character dies, death is used to lock other actions 
#state death is final and ends "Statemachine"
func Die():
	death_sound.play()
	death = true
	anim.play("Death")
	await get_tree().create_timer(1.0).timeout
	emit_signal("disable_fogwall")
	emit_signal("drop_treasure", self.global_position)
	self.queue_free()

#chatacter recieved damage Lock other animations 
func Damaged():
	get_hit_sound.play()
	damaged = true
	hurting = true
	HEALTH -= 10 #CHANGE ONLY FOR TESTING
	damaged = false
	
	
func hurtAnim():
	#if HEALTH >= 0:
	anim.play("Hurt")
	await get_tree().create_timer(0.3).timeout
	hurting = false
	
	
#-------------------------------------- Colissions with certain areas:

#Player entered line of sight
func _on_player_detected_body_entered(body):
	if body.name == "Player" and not player_dead:
		print("chase")
		chase = true

#Player exiteded line of sight
func _on_player_detected_body_exited(body):
	if body.name == "Player":
		chase = false


#Player entered attack zone
func _on_player_in_attack_range_body_entered(body):
	if body.name == "Player":
		attackcounter += 1
		insideAttack = true
		#print(attackcounter)
		attack = true
		
#player exited attack zone 
func _on_player_in_attack_range_body_exited(body):
	if body.name == "Player":
		attack = false
		insideAttack = false

#player hit Pirate boss
func _on_damageble_area_area_entered(area):
	if area.name == "PlayerAttackArea":
		damaged = true


#reset boss hp when player dies-----------------------------------------------
func _on_player_player_death():
	HEALTH = 60
	player_dead = true
func _on_gameworld_reposition_boss_on_revive():
	print("respawned and reposition boss now")
	
	damaged = false
	death = false
	chase = false
	attack = false
	recharge = false
	hurting = false
	attackcounter = 0

	self.global_position = spawn_position
	
	player_dead = false
