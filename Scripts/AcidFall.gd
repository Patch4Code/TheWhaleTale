extends StaticBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var tween = get_tree().create_tween()
var fade_duration = 0.5

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
		$Area2D.monitoring  = false
		$AnimatedSprite2D.visible = false
		
		$Timer.wait_time = 3.0
	
	else:
		$Area2D.monitoring = true
		$AnimatedSprite2D.visible = true 
		
		$Timer.wait_time = 6.0

	elements_active = not elements_active
	$Timer.start()



func _on_area_2d_body_entered(body):
	if body.name == "Player":
		print("Acid Fall entered")
