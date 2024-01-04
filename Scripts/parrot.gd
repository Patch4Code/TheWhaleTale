extends CharacterBody2D

@export var parrot_before_boss_arena = false

func _ready():
	if parrot_before_boss_arena:
		visible = false


func _on_pirate_coin_coin_collected():
	#spawn parrot in front of arena
	if parrot_before_boss_arena:
		visible = true
