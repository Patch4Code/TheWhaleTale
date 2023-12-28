extends Node2D

func _on_button_1_pressed():
	$verschluckt.visible = false
	$Schiff.visible = true
	
func _on_button_2_pressed():
	$Schiff.visible = false
	$Papagei.visible = true

func _on_button_3_pressed():
	$Papagei.visible = false
	$befreit.visible = true

func _on_button_4_pressed():
	$befreit.visible = false
	$Karte.visible = true

func _on_button_5_pressed():
	$Karte.visible = false
	get_tree().change_scene_to_file("res://Scenes/Gameworld.tscn")
