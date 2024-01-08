extends Node2D

var music_player : AudioStreamPlayer

func _ready():
	music_player = $AudioStreamPlayer  # Annahme: Der AudioStreamPlayer befindet sich unter dem Hauptmenü
	music_player.play()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	
	get_tree().change_scene_to_file("res://Scenes/Recap.tscn")
	#var next_scene = preload("res://Scenes/Recap.tscn").instantiate()
	#get_tree().root.add_child($AudioStreamPlayer)
	#get_tree().root.add_child(next_scene)
	


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/Credits.tscn")
