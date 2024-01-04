extends Node2D

func _on_button_1_pressed():
	$RichtungRektum.visible = false
	$ToBeContinued.visible = true
	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
