extends Node2D

var player_inside_zone = false

signal coin_collected

func _process(delta):
	if player_inside_zone:
		if Input.is_action_pressed("Interact"):
			
			#Pagagei muss vor bossarena gespawned werden
			
			#here the inventory is called with the signal
			emit_signal("coin_collected")
			queue_free()


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_inside_zone = true
		$InteractUI.visible = true

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_inside_zone = false
		$InteractUI.visible = false
