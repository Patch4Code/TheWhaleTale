extends StaticBody2D

@onready var anim = get_node("AnimationPlayer")
signal AcidFallHit
var rng = RandomNumberGenerator.new()
var elements_active = true


func _ready():
	create_timer()

# Funktion zum Erstellen und Starten des Timers
func create_timer():
	var random_time = rng.randi_range(1, 10)
	$Timer.wait_time = random_time
	$Timer.start()


# Timer-Funktion
func _on_timer_timeout():
	# Deaktiviere das Area2D und mache den AnimatedSprite unsichtbar
	if elements_active:
		anim.play("vanish")
		$Timer.wait_time = 3.0
	else:
		anim.play("appear")		
		$Timer.wait_time = 6.0

	elements_active = not elements_active
	$Timer.start()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "appear":
		$Area2D.monitoring  = true
		anim.play("Idle")
	elif anim_name == "vanish":
		$Area2D.monitoring = false



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("Acid Fall entered")
		emit_signal("AcidFallHit")



