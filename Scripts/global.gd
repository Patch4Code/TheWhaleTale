extends Node

var found_octootto_item = false
var given_octootto_item = false
var otto_dialog_open = false

var parrot_dialog_open = false

var coinskull_dialog_open = false
var coin_in_possession = false
var coin_already_thrown_in = false

func change_to_ending_scene():
	get_tree().change_scene_to_file("res://Scenes/Ending.tscn")
