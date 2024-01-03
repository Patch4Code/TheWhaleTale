extends CharacterBody2D
var HP = 20
var SPEED = 5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var attacking = false
var damaged = false
var death = false
var health = 10 
var anim

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
		anim.play("Attack")
		

#Play idle if no condition is met
	if chase == false && attacking == false && damaged == false && death == false:
		anim.play("Idle")
		velocity.x = 0
	
	if damaged == true:
		HP = HP - 5
		print(HP)
		if death == false:
			anim.play("Hurt")
			
		
		if HP <= 0:
			death = true
			velocity.x = 0
			anim.play("Death")
			self.queue_free()

	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_player_death_body_entered(body): #has to be edited to be damaged by weapon
	if body.name == "Player":
		damaged = true
		

func _on_player_death_body_exited(body):
	damaged = false

func _on_player_attack_body_entered(body):
	if body.name == "Player":
		attacking = true;
		anim.play("Attack")
		#body.HP -= 1 #Has to be added in later to reduce player health 


func _on_player_attack_body_exited(body):
	attacking = false




