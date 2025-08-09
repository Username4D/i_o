extends CanvasLayer

@export var first = true

func _ready() -> void:
	for i in $buttons.get_children():
		i.pressed.connect(pressed.bind(i.name))
func pressed(button: String) -> void:
	match button:
		"back":
			self.get_parent().get_parent().start_black()
			await ui_handler.black_screen
			if self.get_parent().campaign == true:
				var scene = load("res://campaign_menu.tscn").instantiate()
				self.get_parent().get_parent().add_child(scene)
				self.get_parent().queue_free()
			else:
				var scene = load("res://pre_editor.tscn").instantiate()
				self.get_parent().get_parent().add_child(scene)
				self.get_parent().queue_free()
		"settings":
			self.get_parent().get_parent().start_black()
			await ui_handler.black_screen

			var scene = load("res://scenes/settings.tscn").instantiate()
			scene.id = get_parent().id
			scene.json = get_parent().level_json
			scene.camp = get_parent().campaign
			scene.last = "lvl"
			self.get_parent().get_parent().add_child(scene)
			self.get_parent().queue_free()
		"close":
			self.get_parent().escape()
func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		if event is InputEventJoypadMotion:
			if first and event["axis_value"] != 0.0:
				$buttons/back.grab_focus()
				first = false
		else:
			if first:
				$buttons/back.grab_focus()
				first = false
