extends Node2D

var player_inside_zone = false
signal treasure_collected



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_inside_zone:
		if Input.is_action_pressed("Interact"):	
			global.found_octootto_item = true
			emit_signal("treasure_collected")
			queue_free()



func _on_chestdetection_body_entered(body):
	if body.name == "Player":
		player_inside_zone = true
		$InteractUI.visible = true


func _on_chestdetection_body_exited(body):
	if body.name == "Player":
		player_inside_zone = false
		$InteractUI.visible = false
