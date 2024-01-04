extends Node2D

func _process(delta):
	if global.found_octootto_item == true:
		$chest.visible = false
