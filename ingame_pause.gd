extends CanvasLayer

func _ready() -> void:
	for i in $buttons.get_children():
		i.pressed.connect(pressed.bind(i.name))
func pressed(button: String) -> void:
	match button:
		"back":
			if self.get_parent().campaign == true:
				var scene = load("res://campaign_menu.tscn").instantiate()
				self.get_parent().get_parent().add_child(scene)
				self.get_parent().queue_free()
			else:
				var scene = load("res://pre_editor.tscn").instantiate()
				self.get_parent().get_parent().add_child(scene)
				self.get_parent().queue_free()
		"settings":
			pass
		"close":
			self.get_parent().escape()
