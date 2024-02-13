extends Control

# Please note this is really rough and ugly.
#I could not find my original so had to use the code from the current project.
#This meant stripping out tons of project specific stuff, such as
#localisations/translations, etc, and adding in bits to create a 'working environment'.

# As a consequence we get this, lol.  I hope this helps though.

#This contains all the lable and key value pairings for the gui.
@onready var settings_grid_container: GridContainer = %SettingsGridContainer

#replace with desired save path
@export var save_file:String = "user://current_settings.tres"
@export var game_settings:Resource

var actions:Array
var prompts:Dictionary = {
	"just_for_this_hide": "The HIDE text key(s)",
	"just_for_this_show": "The SHOW text key(s)",
	"just_for_this_keys": "The SWITCH SCENE key(s)",
}

func _ready() -> void:
	load_game_settings()
	
	actions = game_settings.data.keys()

	for each_action in actions:
		var spacer = VSeparator.new()
		spacer.self_modulate = Color(0.0,0.0,0.0,0.0)
		var label = Label.new()
		label.text = prompts[each_action]	#each_action[1]
		var btn = RemapButton.new()
		btn.name = each_action	#game_settings.data[each_action]
		btn.action = each_action	#game_settings.data[each_action]
		btn.active = true
		btn.bind = game_settings.data[each_action]
		settings_grid_container.add_child(label)
		settings_grid_container.add_child(spacer)
		settings_grid_container.add_child(btn)
	

# Just for this save and load functions
func save_game_settings() -> void:
	ResourceSaver.save(game_settings, save_file)

func load_game_settings() -> void:
	if ResourceLoader.exists(save_file):
		game_settings = ResourceLoader.load(save_file)
	else:
		get_tree().change_scene_to_file("res://test_run.tscn")


func _on_save_changes_pressed() -> void:
	var kids:Array = settings_grid_container.get_children()
	for kid in kids:
		if game_settings.data.has(kid.name):
			game_settings.data[kid.name] = kid.bind
	save_game_settings()
	get_tree().change_scene_to_file("res://test_run.tscn")

func _on_cancel_changes_pressed() -> void:
	get_tree().change_scene_to_file("res://test_run.tscn")
