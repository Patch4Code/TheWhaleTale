extends CharacterBody2D

@export var parrot_before_boss_arena = false

var player_in_range = false

func _ready():
	if parrot_before_boss_arena:
		visible = false
		$Area2D.process_mode = Node.PROCESS_MODE_DISABLED

func _on_pirate_coin_coin_collected():
	#spawn parrot in front of arena
	if parrot_before_boss_arena:
		visible = true
		$Area2D.process_mode = Node.PROCESS_MODE_INHERIT

func _process(_delta):
	if player_in_range:
		if Input.is_action_just_pressed("Interact"):
			DialogueManager.show_dialogue_balloon(load("res://parrot.dialogue"), "parrot")
			return

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		$interact_view.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		$interact_view.visible = false
