extends StaticBody2D

var is_open = false
var state_changed = false

@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	collision_shape.disabled = false
	animation_player.play("Idle")

func change_state():
	if state_changed:
		is_open = not is_open
		if is_open:
			animation_player.play("open")
		else:
			animation_player.play_backwards("open")
		

func _on_animation_player_animation_finished(anim_name):
	if not is_open and anim_name == "open":
		animation_player.play("Idle")
