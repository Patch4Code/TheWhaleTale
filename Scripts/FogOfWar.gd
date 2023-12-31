extends Node2D

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("Fog of war entered")
		$Area2D.monitoring = false
		$".".visible = false


