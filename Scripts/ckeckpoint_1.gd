extends Node2D

signal set_start_spawn

func _ready():
	emit_signal("set_start_spawn")


