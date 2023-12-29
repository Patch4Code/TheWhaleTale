extends CharacterBody2D
var HP = 10
var SPEED = 10
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var attacking = false
var health = 10  

func _ready():
	get_node("AnimatedSprite2D").play("Idle") #idle

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if chase == true:
		if get_node("AnimatedSprite2D").animation != "Death" and get_node("AnimatedSprite2D").animation != "Hurt" :
			if attacking == false:
				get_node("AnimatedSprite2D").play("Walk") 
			player = get_node("../Player")
			var direction  = (player.position - self.position).normalized()
	
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = false

			else:
				get_node("AnimatedSprite2D").flip_h = true
			
			velocity.x += direction.x * SPEED

	else:
		if get_node("AnimatedSprite2D").animation != "Death" and get_node("AnimatedSprite2D").animation != "Hurt" :
			
			get_node("AnimatedSprite2D").play("Idle")
			velocity.x = 0
	move_and_slide()


func _on_player_detection_body_entered(body):
	if body.name == "Player":
		chase = true
		

func _on_player_detection_body_exited(body):
	if body.name == "Player":
		chase = false
		
func _on_player_death_body_entered(body): #has to be edited to be damaged by weapon
	if body.name == "Player":
		HP = HP - 5
		print(HP)
		get_node("AnimatedSprite2D").play("Hurt")
		await get_node("AnimatedSprite2D").animation_finished
		get_node("AnimatedSprite2D").play("Idle")
		
		
		if HP <= 0:
			velocity.x = 0
			chase = false
			get_node("AnimatedSprite2D").play("Death")
			await get_node("AnimatedSprite2D").animation_finished
			self.queue_free()


func _on_player_attack_body_entered(body):
	if body.name == "Player":
		attacking = true;
		get_node("AnimatedSprite2D").play("Attack")
		#body.HP -= 1 #Has to be added in later to reduce player health 


func _on_player_attack_body_exited(body):
	attacking = false
