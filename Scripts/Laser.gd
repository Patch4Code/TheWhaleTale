extends Node2D

@onready var ray = $RayCast2D
@onready var line = $Line2D

func _process(delta):
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	ray.global_position = line.global_position
	ray.target_position = ray.global_position + Vector2(1, 0) * 1000
	ray.force_raycast_update()
	
	while true:
		if not ray.is_colliding():
			var pt = ray.global_position + ray.target_position
			line.add_point(line.to_local(pt))
			break
		
		var coll = ray.get_collider()
		var pt = ray.get_collision_point()
		
		line.add_point(line.to_local(pt))
		
		if not coll.is_in_group("Mirror"):
			break
			
		var normal = ray.get_collision_normal()
		if normal == Vector2.ZERO:
			break
		
		ray.global_position = pt
		ray.target_position = ray.target_position.bounce(normal)
		ray.force_raycast_update()
		
		
			
			
			
	
