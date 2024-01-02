extends Node2D

var music_player : AudioStreamPlayer

func _ready():
	music_player = $AudioStreamPlayer  # Annahme: Der AudioStreamPlayer befindet sich unter dem Hauptmenü
	music_player.play()

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	var next_scene = preload("res://Scenes/Recap.tscn").instantiate()
	
	get_tree().root.add_child($AudioStreamPlayer)
	get_tree().root.add_child(next_scene)
	
