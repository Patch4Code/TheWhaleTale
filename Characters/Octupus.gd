extends CharacterBody2D

var player_in_range = false

@onready var otto_sound = $ottoSound

func _process(_delta):
	if player_in_range:
		if Input.is_action_just_pressed("Interact"):
			if not global.otto_dialog_open:
				otto_sound.play()
			DialogueManager.show_example_dialogue_balloon(load("res://Scripts/Dialog/main.dialogue"), "main")
			return


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$interactionUi.visible = true
		player_in_range = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$interactionUi.visible = false
		player_in_range = false
