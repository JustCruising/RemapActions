extends Control

@onready var action_to_show_text: Label = %ActionToShowText
@onready var action_to_hide_text: Label = %ActionToHideText
@onready var action_to_change_scene: Label = %ActionToChangeScene
@onready var text_shown_or_hidden: Label = %TextShownOrHidden

@export var save_file:String = "user://current_settings.tres"
var game_settings:Resource

func _ready() -> void:

	# first time in get the saved keys and set the mapping
	#	(as updating the project settings does not persist across restarts)
	# or create the 'saved game' resource

	if ResourceLoader.exists(save_file):
		game_settings = ResourceLoader.load(save_file)
		var keys = game_settings.data.keys()
		for key in keys:
			InputMap.action_erase_events(key) # erases ALL possibles, for this example
			InputMap.action_add_event(key, game_settings.data[key])
	else:
		game_settings = ResourceLoader.load("res://resources/current_settings_default.tres")
		get_action_value("just_for_this_hide")
		get_action_value("just_for_this_show")
		get_action_value("just_for_this_keys")
		ResourceSaver.save(game_settings, save_file)

	# set up the key code prompts

	action_to_show_text.text = game_settings.data["just_for_this_show"].as_text()
	action_to_hide_text.text = game_settings.data["just_for_this_hide"].as_text()
	action_to_change_scene.text = game_settings.data["just_for_this_keys"].as_text()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("just_for_this_show"):
		text_shown_or_hidden.self_modulate = Color(1.0,1.0,1.0,1.0)
	if Input.is_action_just_pressed("just_for_this_hide"):
		text_shown_or_hidden.self_modulate = Color(1.0,1.0,1.0,0.0)
	if Input.is_action_just_pressed("just_for_this_keys"):
			get_tree().change_scene_to_file("res://gui/action_mapping.tscn")


func get_action_value(key_name:String) -> void:
	var event = InputMap.action_get_events(key_name)

	#This only gets the first action mapped.
	#If there are several this will ignore the rest.
	#If there are none it ignores.
	#So not very dynamic/flexible
	if event.size() > 0:
		if game_settings.data.has(key_name):
			game_settings.data[key_name] = event[0]

