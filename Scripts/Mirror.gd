extends StaticBody2D

var rotation_speed = 0.5

var player_inside_zone = false

@export var interact_ui_elemnt : Sprite2D = null


func _process(delta):
	# Überprüfen Sie die Entfernung zum Spieler
	
	if player_inside_zone:
		# Wenn der Spieler in der Nähe ist, überprüfen Sie die Eingabe für die Taste "E"
		if Input.is_action_pressed("Interact"): #press e
			# Rotieren Sie das Objekt
			rotate_object(delta)
		if Input.is_action_pressed("Interact2"): #press q
			# Rotieren Sie das Objekt
			rotate_object(-delta)

func rotate_object(delta):
	# Rotieren Sie das Objekt basierend auf der Eingabe und der Geschwindigkeit
	rotate(rotation_speed * delta)


func _on_interaction_zone_body_entered(body):
	if body.name == "Player":
		if interact_ui_elemnt != null:
			print("interact_ui_elemnt != null")
			interact_ui_elemnt.visible = true
		player_inside_zone = true


func _on_interaction_zone_body_exited(body):
	if body.name == "Player":
		if interact_ui_elemnt != null:
			interact_ui_elemnt.visible = false
		player_inside_zone = false
