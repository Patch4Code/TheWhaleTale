extends Node2D

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		$"../../../BossMusic".playing = true
		$"../../../MainGameMusic".playing = false
		
		
		print("Fog of war entered")
		$Area2D.monitoring = false
		$".".visible = false

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$"../../../BossMusic".playing = false
		$"../../../MainGameMusic".playing = true
