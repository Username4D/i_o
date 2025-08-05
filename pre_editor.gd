extends Node2D

var positions = Vector2(0, 160)
var bt = preload("res://level_button.tscn")

func _ready() -> void:
	var json = JSON.parse_string(load_lfrom_file("levels.txt"))
	for i in json:
		var but = bt.instantiate()
		but.lname = i
		but.position = positions
		positions += Vector2(0, 64)
		$levels.add_child(but)
func load_editor(lvl):
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
	var editor = load("res://scenes/editor.tscn").instantiate()
	editor.load = false
	self.get_parent().add_child(editor)
	self.queue_free()
func play(lvl):
	var level = load("res://scenes/level_viewport.tscn").instantiate()
	level.level_json = load_from_file(lvl)
	self.get_parent().add_child(level)
	self.queue_free()
