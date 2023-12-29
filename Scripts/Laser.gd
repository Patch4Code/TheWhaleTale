extends Node2D

const MAX_BOUNCES = 5

@onready var ray = $RayCast2D
@onready var line = $Line2D

func _ready():
	var door_script = get_node("res://Scripts/door.gd")

func _process(delta):
	
	line.clear_points()
	line.add_point(Vector2.ZERO)
	
	ray.global_position = line.global_position
	ray.target_position = ((line.global_position+Vector2(1000,0))-line.global_position).normalized()*1000
	ray.force_raycast_update()
	
	var prev = null
	var bounces = 0
	
	while true:
		if not ray.is_colliding():
			var pt = ray.global_position + ray.target_position
			line.add_point(line.to_local(pt))
			break
		
		var coll = ray.get_collider()
		var pt = ray.get_collision_point()
		
		line.add_point(line.to_local(pt))
		
		#if coll.is_in_group("LightSensor"):
			#print("Lightsensor active")
		#else:
			#print("Lightsensor not active")
		
		if not coll.is_in_group("Mirror"):
			break
			
		var normal = ray.get_collision_normal()
		if normal == Vector2.ZERO:
			break
		
		#update collisions
		if prev != null:
			prev.collision_mask = 2
			prev.collision_layer = 2
		prev = coll
		prev.collision_mask = 0
		prev.collision_layer = 0
		
		#update raycast
		ray.global_position = pt
		ray.target_position = ray.target_position.bounce(normal)
		ray.force_raycast_update()
	
		#prevent infinite loop
		bounces += 1
		if bounces >= MAX_BOUNCES:
			break
	
	if prev != null:
		prev.collision_mask = 2
		prev.collision_layer = 2
