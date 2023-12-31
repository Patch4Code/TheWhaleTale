extends Node2D

signal make_fogwall_passable

var player_inside_zone = false
var coin_in_possession = false

func _process(delta):
	if player_inside_zone:
		#Eingabe abfragen
		if Input.is_action_pressed("Interact"): #press e
			if coin_in_possession:
				print("Münzeinwurf") #hier muss noich etwas viuell eingeblendet werden Sprechblase o.Ä.
				emit_signal("make_fogwall_passable")
			else:
				print("Keine Münze vorhanden") #Einblendung dass man keine Münze hat


func _on_area_2d_body_entered(body):
	#Interagieren Anzeige einblenden
	print("Coin Area entered")
	player_inside_zone = true
	

func _on_area_2d_body_exited(body):
	print("Coin Area exited")
	player_inside_zone = false

