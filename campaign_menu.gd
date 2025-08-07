extends Node2D

var button_scene = preload("res://scenes/campaign_button.tscn")
var first: Node
var last: Node
@export var cleft = true
@export var cright = true

func _ready() -> void:
	for i in range(1, 3):
		var lvl_json = FileAccess.open("user://data/campaign_levels/" + var_to_str(i)+ ".txt", FileAccess.READ)
		var lvl = JSON.parse_string(lvl_json.get_as_text())
		var stats_json = FileAccess.open("user://data/campaign_info/" + var_to_str(i)+ ".txt", FileAccess.READ)
		print("user://data/campaign_info/" + var_to_str(i)+ ".txt")
		var info = JSON.parse_string(stats_json.get_as_text())
		var button = button_scene.instantiate()
		button.position = Vector2(576 * i, 320)
		var meta = lvl["meta"]
		button.lname = meta["name"]
		button.medal = info["medal"]
		button.pb = info["pb"]
		button.json = lvl_json.get_as_text()
		button.id = i
		$buttons.add_child(button)
		button.init()
		if i == 1:
			first = button
		last = button
	update()
func play(js, id) -> void:
	var scene = load("res://scenes/level_viewport.tscn")
	var obj = scene.instantiate()
	obj.level_json = js
	obj.campaign = true
	obj.id = id
	self.get_parent().add_child(obj)
	self.queue_free()
func update():
	if first.position.x > 550:
		cleft = false
	else:
		cleft = true
	if last.position.x < 600:
		cright = false
	else:
		cright = true
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right"):
		update()
	if Input.is_action_just_pressed("ui_escape"):
		var new = load("res://main_menu.tscn").instantiate()
		self.get_parent().add_child(new)
		self.queue_free()
