extends Button
class_name RemapButton

@export var action:String
@export var slot:int
@export var active:bool = false
@export var bind:InputEvent

var ignore:Array = [
	KEY_CTRL,
	KEY_ALT,
	KEY_SHIFT,
	KEY_META,
]

func _init():
	toggle_mode = true
	
func _ready():
	set_process_unhandled_input(false)
	update_key_text()
	
	
func _toggled(btn_pressed):
	set_process_unhandled_input(btn_pressed)
	if btn_pressed:
		text = "... Awaiting Input ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()

func _unhandled_input(event):
	if event is InputEventJoypadButton:
		pass
	elif event is InputEventJoypadMotion:
		pass
	else:
		if event.keycode == KEY_ESCAPE:
			button_pressed = false
		elif not ignore.has(event.keycode):
			InputMap.action_erase_event(action, event)
			InputMap.action_add_event(action, event)
			bind = event
			button_pressed = false

func update_key_text():
	text = "%s" % bind.as_text()
