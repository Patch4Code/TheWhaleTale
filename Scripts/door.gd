extends StaticBody2D

var is_open = false


@onready var collision_shape : CollisionShape2D = $CollisionShape2D
@onready var animation_player : AnimationPlayer = $AnimationPlayer

func _ready():
	collision_shape.disabled = false
	animation_player.play("Idle")


func _on_laser_open_door_signal():
	if not is_open:
		is_open = true
		animation_player.play("open")

func _on_laser_close_door_signal():
	if is_open:
		is_open = false
		animation_player.play_backwards("open")


func _on_animation_player_animation_finished(anim_name):
	if not is_open and anim_name == "open":
		animation_player.play("Idle")
