extends Node2D

var button_scene = preload("res://scenes/campaign_button.tscn")

func _ready() -> void:
	for i in range(1, 2):
		var lvl_json = FileAccess.open("user://data/campaign_levels/" + var_to_str(i)+ ".txt", FileAccess.READ)
		var lvl = JSON.parse_string(lvl_json.get_as_text())
		var stats_json = FileAccess.open("user://data/campaign_info/" + var_to_str(i)+ ".txt", FileAccess.READ)
		var info = JSON.parse_string(stats_json.get_as_text())
		var button = button_scene.instantiate()
		button.position = Vector2(576 * i, 320)
		var meta = lvl["meta"]
		button.lname = meta["name"]
		button.medal = info["medal"]
		button.pb = info["pb"]
		button.json = lvl_json.get_as_text()
		$buttons.add_child(button)
		button.init()
func play(js) -> void:
	var scene = load("res://scenes/level_viewport.tscn")
	var obj = scene.instantiate()
	obj.level_json = js
	self.get_parent().add_child(obj)
	self.queue_free()
