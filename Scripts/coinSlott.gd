extends Node2D

signal make_fogwall_passable
signal coin_thrown_in

#var coin_in_possession = false

var player_inside_zone = false
#var coin_already_thrown_in = false
var throw_coin_in_block = false

func _process(_delta):
	
	if player_inside_zone:
		#Eingabe abfragen
		if Input.is_action_pressed("Interact"): #press e
			DialogueManager.show_dialogue_balloon(load("res://coinskull.dialogue"), "coinskull")
			return
	
	if global.coin_already_thrown_in and throw_coin_in_block == false:
		emit_signal("coin_thrown_in")
		emit_signal("make_fogwall_passable")
		throw_coin_in_block == true

func _on_area_2d_body_entered(_body):
	#Interagieren Anzeige einblenden
		player_inside_zone = true
		$InteractUI.visible = true
	

func _on_area_2d_body_exited(_body):
	player_inside_zone = false
	$InteractUI.visible = false



func _on_inventory_pirate_coin_in_possession():
	global.coin_in_possession = true
