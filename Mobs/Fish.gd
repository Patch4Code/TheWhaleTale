extends CharacterBody2D
var HP = 5
var SPEED = 5
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var attacking = false
var death = false
var hurt = false

@onready var attack_sound = $attackSound
@onready var get_hit_sound = $getHitSound
@onready var death_sound = $DeathSound

func _ready():
	get_node("AnimatedSprite2D").play("Idle") #idle

func _physics_process(delta):
	velocity.y += gravity * delta
	
	if chase == true:
		if death == false and hurt == false and attacking == false:
			get_node("AnimatedSprite2D").play("Walk") 
			player = get_node("../Player")
			var direction  = (player.position - self.position).normalized()
	
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = false

			else:
				get_node("AnimatedSprite2D").flip_h = true
			
			velocity.x += direction.x * SPEED

	else:
		if death == false and hurt == false and attacking == false :
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
		hurt = true
		get_hit_sound.play()
		damageMe(20)

func _on_player_death_area_entered(area):
	if area.name == "PlayerAttackArea":
		velocity.y = 0
		hurt = true
		get_hit_sound.play()
		damageMe(20)
		

func damageMe(damageDealt : int):
	HP = HP - damageDealt
	print(HP)
	if HP > 0:
		get_node("AnimatedSprite2D").play("Hurt")
		await get_node("AnimatedSprite2D").animation_finished
		get_node("AnimatedSprite2D").play("Idle")
	var hurt = false
	if HP <= 0:
		death == true
		velocity.x = 0
		chase = false
		death_sound.play()
		get_node("AnimatedSprite2D").play("Death")
		await get_node("AnimatedSprite2D").animation_finished
		self.queue_free()


func _on_player_attack_fish_body_entered(body):
	if body.name == "Player":
		attacking = true;
		if HP > 0:
			get_node("AnimatedSprite2D").play("Attack")
			attack_sound.play()


func _on_player_attack_fish_body_exited(_body):
	attacking = false
