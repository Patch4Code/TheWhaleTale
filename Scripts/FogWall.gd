extends StaticBody2D

func make_fogwall_passable():
	$CollisionShape2D.one_way_collision = true
	
func disable_fogwall():
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false
