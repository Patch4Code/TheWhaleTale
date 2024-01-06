extends Node2D

@export var start_respawn: Node2D
@export var second_respawn: Node2D

signal player_revived

var current_respawn

func _ready():
	current_respawn = start_respawn
	$Checkpoint2.process_mode = Node.PROCESS_MODE_DISABLED

func respawn_player():
	$Player/DeathScreen.visible = true
	await get_tree().create_timer(4).timeout
	$Player/DeathScreen.visible = false
	emit_signal("player_revived")
	$Player.position = current_respawn.global_position

#activate respawn2 detection zone
func _on_pirate_coin_coin_collected():
	$Checkpoint2.process_mode = Node.PROCESS_MODE_INHERIT
	
#detection for activation of second spawn
func _on_new_checkpoint_detection_body_entered(body):
	if current_respawn != second_respawn:
		if body.name == "Player":
			print("respawn changed")
			current_respawn = second_respawn
	

func _on_player_player_death():
	respawn_player()

func _process(_delta):
	if global.found_octootto_item == true:
		$chest.visible = false



