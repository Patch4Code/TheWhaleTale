extends StaticBody2D

var collisionShape: CollisionShape2D

func _ready():
	collisionShape = $CollisionShape2D

func _on_area_2d_body_entered(body):
	var time_to_collapse = 2
	await get_tree().create_timer(time_to_collapse).timeout
	collisionShape.disabled = true
	$Sprite2D.visible = false
	
	var time_to_rebuild = 3
	await get_tree().create_timer(time_to_rebuild).timeout
	collisionShape.disabled = false
	$Sprite2D.visible = true
	
	
	
	
