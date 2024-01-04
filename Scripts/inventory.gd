extends Node2D

signal pirate_coin_in_possession
signal pirate_treasure_in_possession

func _on_pirate_coin_coin_collected():
	$Items/PirateCoin.visible = true
	emit_signal("pirate_coin_in_possession")

func _on_coin_slot_coin_thrown_in():
	$Items/PirateCoin.visible = false
	

#on treasure collected






