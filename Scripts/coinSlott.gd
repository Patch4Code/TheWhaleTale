extends Node2D

signal make_fogwall_passable
signal coin_thrown_in

var coin_in_possession = false

var player_inside_zone = false
var coin_already_thrown_in = false


func _process(delta):
	
	if player_inside_zone:
		#Eingabe abfragen
		if Input.is_action_pressed("Interact"): #press e
			if coin_in_possession:
				print("Münzeinwurf") #hier muss noich etwas viuell eingeblendet werden Sprechblase o.Ä.
				emit_signal("coin_thrown_in")
				emit_signal("make_fogwall_passable")
				coin_in_possession = false
				coin_already_thrown_in = true
			else:
				print("Keine Münze vorhanden") #Einblendung dass man keine Münze hat


func _on_area_2d_body_entered(body):
	#Interagieren Anzeige einblenden
	if not coin_already_thrown_in:
		print("Coin Area entered")
		player_inside_zone = true
		$InteractUI.visible = true
	

func _on_area_2d_body_exited(body):
	print("Coin Area exited")
	player_inside_zone = false
	$InteractUI.visible = false



func _on_inventory_pirate_coin_in_possession():
	coin_in_possession = true
