extends StaticBody2D

#Funktionen müssen noch angepasst werden, dass diese Später durch Signal aktiviert werden können
# (bei einwerfen Münze Aufruf Inhalt make_fogwall_passable() und bei besiegen des Bosses Aufruf disable_fogwall()
# Signale habe ich schon beim Laser in Kombination mit der door verwendet

func _on_coin_slot_make_fogwall_passable():
	$CollisionShape2D.one_way_collision = true
	
	
#func disable_fogwall():
	



func _on_pirate_boss_2_disable_fogwall():
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
