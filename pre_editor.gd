extends Node2D

var positions = Vector2(0, 160)
var bt = preload("res://level_button.tscn")



func _ready() -> void:
	var json = JSON.parse_string(load_lfrom_file("levels.txt"))
	var first = true
	for i in json:
		
		var but = bt.instantiate()
		but.lname = i
		but.position = positions
		positions += Vector2(0, 64)
		$levels/VBoxContainer.add_child(but)
		if first:
			but.grab()
		first = false
func load_editor(lvl):
	self.get_parent().start_black()
	await ui_handler.black_screen
	var editor = load("res://scenes/editor.tscn").instantiate()
	editor.load = true
	editor.json = load_from_file(lvl)
	self.get_parent().add_child(editor)
	self.queue_free()
func load_from_file(lvl):
	var file = FileAccess.open("user://"+ lvl + ".txt", FileAccess.READ)
	print("user://" + lvl + ".txt")

	var content = ""
	if file:
		content = file.get_as_text()
	return content
func load_lfrom_file(fname):
	var file = FileAccess.open("user://data/" + fname, FileAccess.READ)
	var content = file.get_as_text()
	return content
func _on_button_pressed() -> void:
	self.get_parent().start_black()
	await ui_handler.black_screen
	var editor = load("res://scenes/editor.tscn").instantiate()
	editor.load = false
	self.get_parent().add_child(editor)
	self.queue_free()
func play(lvl):
	self.get_parent().start_black()
	await ui_handler.black_screen
	var level = load("res://scenes/level_viewport.tscn").instantiate()
	level.level_json = load_from_file(lvl)
	level.campaign = false
	self.get_parent().add_child(level)
	self.queue_free()
func delete(lvl, node):
	var dic = JSON.parse_string(load_lfrom_file("levels.txt"))
	dic.erase(lvl)
	save_to_file(JSON.stringify(dic), "data/levels.txt")
	node.queue_free()
	var dir = DirAccess.open("user://")
	dir.remove(lvl+".txt")
	dir.remove_absolute(lvl+".txt")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_escape"):
		self.get_parent().start_black()
		await ui_handler.black_screen
		var new = load("res://main_menu.tscn").instantiate()
		self.get_parent().add_child(new)
		self.queue_free()
func save_to_file(content, fname):
	var file = FileAccess.open("user://" + fname, FileAccess.WRITE)
	file.store_string(content)
