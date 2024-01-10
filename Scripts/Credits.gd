extends Node2D

const section_time := 2.0
const line_time := 0.3
const base_speed := 100
const speed_up_multiplier := 10.0
const title_color := Color.WEB_GRAY

var speed_up := false

@onready var line := $CreditsContainer/Line
var started := false
var finished := false

var section
var section_next := true
var section_timer := 0.0
var line_timer := 0.0
var curr_line := 0
var lines := []

var credits = [
	[
		"The Whale Tale"
	],[
		"Entwickler",
		"Moritz N.",
		"Michael R.",
		"Felix E."
	],[
		"Verwendete Assets",
		"FREE FANTASY CHIBI MALE SPRITES PIXEL ART",
		"craftpix.net",
		"",
		"Parrot by Luna16",
		"spriters-resource.com",
		"",
		"Giant Octopus by Ragnarocker",
		"spriters-resource.com",
		"",
		"PLATFORMER/METROIDVANIA ASSET PACK",
		"itch.io",
		"",
		"WaterFall by JoMI",
		"itch.io",
		"",
		"Living Tissue Platform Environment by Ansimuz",
		"gamedevmarket.net",
		"",
		"OPP 2017 - Cave and mine cart by Open Pixel Project",
		"itch.io",
		"",
		"styled pixel art wood planks tileset by iPixl",
		"itch.io",
		""
	],[
		"Verwendeter Script- und Shadercode sowie Addons",
		"godot_dialogue_manager addon by Nathan Hoad",
		"MIT License Copyright (c) 2022-present Nathan Hoad and Dialogue Manager contributors.",
		"github.com",
		"",
		"godot-credits by benbishopnz",
		"github.com",
		"",
		"Wind Waker 2d Water Shader Canvas_Item by GeistDev",
		"godotshaders.com",
		"",
		"2D Procedural Water by flytrap",
		"godotshaders.com",
		"",
		"Shard Noise by Zenryoku",
		"godotshaders.com",
		""
	],[
		"Musik",
		"Mysterious Adventure by Alexander Nakarada",
		"(www.creatorchords.com)",
		"Licensed under Creative Commons BY Attribution 4.0 License",
		"",
		"Guitar Melody - 'Imitation' by jackson reang",
		"samplefocus.com",
		"",
		" 'I am the Sea' - Epic Pirate Battle Music",
		"supported by #TheROOMnoCopyRMusic",
		"youtube.com",
		"",
		"Journey (Cinematic) from 'yet-another-free-music-pack' by Clement Panchout",
		"itch.io",
		"clementpanchout.com",
		"Licensed under Creative Commons Attribution 4.0 International (CC BY 4.0)",
		""
		
	],[
		"Sound Effekte",
		"rpg-essentials-sfx-free by Leohpaz",
		"itch.io",
		"",
		"Tubular Bell of Death by ani_music",
		"freesound.org",
		"",
		"PARROT SQUAWKS SOUND by https://quicksounds.com",
		"quicksounds.com",
		"",
		"Landlubber! - pirate (Male) by Joshua Chivers",
		"uppbeat.io",
		"",
		"Arrr - pirate (Male) by Joshua Chivers",
		"uppbeat.io",
		"",
		"Balbuceos_01.wav by hachiman935",
		"freesound.org",
		""
	],[
		"Fonts und Designelemente",
		"Bell MT Font by Richard Austin",
		"",
		"Baskerville Old Face Font by Isaac Moore",
		"",
		"Comic Sans Font by Vincent Connare",
		"",
		"Hand-drawn divider collection designed by Freepik",
		"www.freepik.com",
		""
	],[
		"Verwendete Tools",
		"Developed with Godot Engine",
		"godotengine.org/license",
		"",
		"Bing Image Creator based on DALL·E 3",
		"bing.com/images/create",
		"",
		"Leonardo Ai - Image Creator",
		"leonardo.ai",
		"",
		"LeiaPix AI _ Image Animation",
		"leiapix.com",
		"",
		"Affinity Designer / Affinity Photo",
		"affinity.serif.com"
	],[
		"Besonderer Dank",
		"Papagei - König des Schiffs",
		"",
		"Du bist cool! ;)"
	]
]


func _process(delta):
	var scroll_speed = base_speed * delta
	
	if section_next:
		section_timer += delta * speed_up_multiplier if speed_up else delta
		if section_timer >= section_time:
			section_timer -= section_time
			
			if credits.size() > 0:
				started = true
				section = credits.pop_front()
				curr_line = 0
				add_line()
	
	else:
		line_timer += delta * speed_up_multiplier if speed_up else delta
		if line_timer >= line_time:
			line_timer -= line_time
			add_line()
	
	if speed_up:
		scroll_speed *= speed_up_multiplier
	
	if lines.size() > 0:
		for l in lines:
			l.position.y -= scroll_speed
			if l.position.y < -l.get_line_height():
				lines.erase(l)
				l.queue_free()
	elif started:
		finish()


func finish():
	#print("finish")
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")

		


func add_line():
	var new_line = line.duplicate()
	new_line.text = section.pop_front()
	lines.append(new_line)
	if curr_line == 0:
		# new_line.add_color_override("font_color", title_color)
		new_line.set("theme_override_colors/font_color", title_color)
	$CreditsContainer.add_child(new_line)
	
	if section.size() > 0:
		curr_line += 1
		section_next = false
	else:
		section_next = true


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		finish()
	if event.is_action_pressed("ui_down") and !event.is_echo():
		speed_up = true
	if event.is_action_released("ui_down") and !event.is_echo():
		speed_up = false
