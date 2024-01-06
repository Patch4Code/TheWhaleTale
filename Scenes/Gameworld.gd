extends Node2D

@export var start_respawn: Node2D
@export var second_respawn: Node2D

signal player_revived

var current_respawn

func _ready():
	current_respawn = start_respawn

func respawn_player():
	$Player/DeathScreen.visible = true
	await get_tree().create_timer(4).timeout
	$Player/DeathScreen.visible = false
	emit_signal("player_revived")
	$Player.position = current_respawn.global_position
	

func _on_player_player_death():
	respawn_player()

func _process(delta):
	if global.found_octootto_item == true:
		$chest.visible = false




