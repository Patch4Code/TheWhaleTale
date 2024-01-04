extends Node2D

var menu_active = false
var input_delay = 0.5  
var last_input_time = 0.0

#func _ready():
	#$MenuView.set_process(false)
	#$ControllsView.set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_pressed("ui_cancel") and can_handle_input(): 
		if not menu_active:
			menu_active = true
			$MenuView.visible = true
			#$MenuView.set_process(true)
			print("Activated Menu")
		else:
			menu_active = false
			$MenuView.visible = false
			$ControllsView.visible = false
			#$MenuView.set_process(false)
			print("Dectivated")
		last_input_time = Time.get_ticks_msec()

func can_handle_input():
	return Time.get_ticks_msec() - last_input_time > input_delay * 1000.0		
		
			
func _on_weiter_pressed():
	menu_active = false
	$MenuView.visible = false
	#$MenuView.set_process(false)
	print("Dectivated")

func _on_steuerung_pressed():
	$MenuView.visible = false
	#$MenuView.set_process(false)	
	$ControllsView.visible = true
	#$ControllsView.set_process(true)

func _on_hauptmenu_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	
	

#back from controlls view to pasue menu view
func _on_zurück_pressed():
	$ControllsView.visible = false
	#$ControllsView.set_process(false)
	$MenuView.visible = true
	#$MenuView.set_process(true)	
	
