extends Node2D

var valid_chars_num = ["0","1","2","3","4","5","6","7","8","9"]

var last = "main"
@export var camp = false
@export var json: String
@export var id: int
func _on_max_fps_text_submitted(new_text: String) -> void:
	check_text($Control/max_fps, valid_chars_num)
func check_text(obj: Node, sets: Array) -> void:
	var text = obj.text
	var newtext = ""
	var dots = 0
	if text:
		for i in range(0, text.length(), 1):
			var out = ""
			var c = text[i]
			for n in sets:
				if c == n or c == n.capitalize():
					if c != ".":
						out = c
					else:
						if dots == 0:
							dots = 1
							out = c
			newtext += out
		obj.text = newtext
	if obj.text == "":
		obj.text = obj.placeholder_text
func _process(delta: float) -> void:
	if $Control/vsync.button_pressed:
		$Control/max_fps.modulate.a = 0.5
	else:
		$Control/max_fps.modulate.a = 1
	if Input.is_action_just_pressed("ui_escape"):
		if last == "main":
			self.get_parent().start_black()
			await ui_handler.black_screen
			var level = load("res://main_menu.tscn").instantiate()
			self.get_parent().add_child(level)
			self.queue_free()
		else:
			self.get_parent().start_black()
			await ui_handler.black_screen
			var level = load("res://scenes/level_viewport.tscn").instantiate()
			level.level_json = json
			level.campaign = camp
			level.id = id
			self.get_parent().add_child(level)
			self.queue_free()
func _on_button_pressed() -> void:
	await get_tree().process_frame
	if $Control/vsync.button_pressed:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Engine.max_fps = int($Control/max_fps.text)
