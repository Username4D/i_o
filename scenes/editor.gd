extends Node2D

# display down
var current_display = "blocks"
var editor_obj = preload("res://scenes/editor_obj.tscn")

# general
@export var mode = "none"
@export var load = false
@export var json: String
# settings
var settings_open = true

# save/load
var levels_array = []

func _process(delta: float) -> void:
	process_dd()
	$ColorRect.visible = not settings_open
func _ready() -> void:
	$display_down/b_blocks.pressed.connect(update_dd.bind("blocks"))
	$display_down/b_obstacles.pressed.connect(update_dd.bind("obstacles"))
	$display_down/b_special.pressed.connect(update_dd.bind("special"))
	for i in $display_down/rows.get_children():
		for c in i.get_children():
			c.pressed.connect(pressed_dd.bind(c.name, c))
	$display_up/move.pressed.connect(pressed_ud.bind($display_up/move))
	$display_up/rotate.pressed.connect(pressed_ud.bind($display_up/rotate))
	$display_up/scale.pressed.connect(pressed_ud.bind($display_up/scale))
	$display_up/delete.pressed.connect(pressed_ud.bind($display_up/delete))
	$settings.get_node("close").pressed.connect(_on_setting_pressed)
	if load:
		loadl()
func process_dd() -> void:
	pass
func update_dd(b) -> void:
	current_display = b
	for i in $display_down/rows.get_children():
		if i.name == b:
			i.visible = true
		else:
			i.visible = false
func pressed_dd(obj, node) -> void:
	if node.visible:
		var new = editor_obj.instantiate()
		new.position = Vector2(576,320)
		new.obj = obj
		new.init()
		$level.add_child(new)
func pressed_ud(obj):
	mode = obj.name
func _on_setting_pressed() -> void:
	await get_tree().process_frame
	if $settings.medals[0] <= $settings.medals[1] and $settings.medals[1] <= $settings.medals[2]:
		$settings.error("none")
		for i in range(0.0, 20.0,1.0):
			$settings.offset.y = 648 * GlobalFunctions.easeInOutQuad(1 -(i / 20.0)) if settings_open else 648 * GlobalFunctions.easeInOutQuad( i / 20.0)
			$ColorRect.material.set_shader_parameter("blur_strength", i /10 + 0.1 if  settings_open else 1 - i / 10 + 0.1)
			await get_tree().process_frame
			await get_tree().process_frame
		
	
		settings_open = false if settings_open else true
	else:
		$settings.error("order")
func save() -> int:
	var objects = []
	for i in $level.get_children():
		objects.append({"position": i.position, "scale": i.scale, "object": i.obj, "rotation": i.rot})
	var meta = {"name": $settings.level_name, "medals": $settings.medals, "last_edit": Time.get_date_dict_from_system(), "palette": $settings.palette, "spawn": $spawn.position}	
	var level = {"objects": objects, "meta": meta}
	var dic = JSON.parse_string(load_from_file("levels.txt"))
	levels_array = dic
	if levels_array.find($settings.level_name) != -1 and not load:
		print("f")
		if await confirm() == 0:
			return 0
	load =true
	var json = JSON.stringify(level, "\t")
	await get_tree().process_frame
	save_to_file(json, $settings.level_name + ".txt")
	levels_array.erase($settings.level_name)
	levels_array.insert(0, $settings.level_name)
	save_to_file(JSON.stringify(levels_array), "data/levels.txt")
	print("saved")
	return 0
func loadl():
	var data = JSON.parse_string(json)
	var objects = data["objects"]
	for i in objects:
		var ins = editor_obj.instantiate()
		ins.obj = i["object"]
		ins.position = GlobalFunctions.string_to_vector2(i["position"])
		ins.scale =GlobalFunctions.string_to_vector2(i["scale"])
		ins.rot = i["rotation"]
		$level.add_child(ins)
		ins.init()
		ins.ldinit()
	var meta = data["meta"]
	print(GlobalFunctions.string_to_vector2(meta["spawn"]))
	$spawn.position = GlobalFunctions.string_to_vector2(meta["spawn"])
	
	$settings.medals = meta["medals"]
	$settings.level_name = meta["name"]
	$settings.palette = meta["palette"]
	$settings.init()
func save_to_file(content, fname):
	var file = FileAccess.open("user://" + fname, FileAccess.WRITE)
	file.store_string(content)
func load_from_file(fname):
	var file = FileAccess.open("user://data/" + fname, FileAccess.READ)
	var content = file.get_as_text()
	return content
func confirm():
	for i in range(0.0, 20.0,1.0):
		$settings2.offset.y = 648 * GlobalFunctions.easeInOutQuad(1 -(i / 20.0))
		$ColorRect.material.set_shader_parameter("blur_strength", i /10 + 0.1)
		await get_tree().process_frame
		await get_tree().process_frame
	await $settings2.lol
	print("yoooooo")
	await get_tree().process_frame
	close_confirm()
	if $settings2.out == "save":
		pass
		print("xd")
		return 1
	else:
		return 0
func close_confirm():
	for i in range(0.0, 20.0,1.0):
			$settings2.offset.y =648 * GlobalFunctions.easeInOutQuad( i / 20.0)
			$ColorRect.material.set_shader_parameter("blur_strength",1 - i / 10 + 0.1)
			await get_tree().process_frame
			await get_tree().process_frame
