extends Node2D

var level = preload("res://scenes/test_scene.tscn")
var player: Node
@export var started = false
@export var running = false
@export var level_json = ""
@onready var objects_sc = {"block": preload("res://scenes/block.tscn"), "spike": preload("res://scenes/spike.tscn"), "orb": preload("res://scenes/orb.tscn"), "fin": preload("res://scenes/fin.tscn")}
@export var campaign = false
var menu_switch = false
@export var id = 1
var meta
func _ready() -> void:
	var lvl = level.instantiate()
	lvl.name = "level"
	
	player = lvl.get_node("players/player")
	$level.add_child(lvl)
	read_json(level_json, 0)
	player.position = GlobalFunctions.string_to_vector2(meta["spawn"])  - Vector2(64, 0)
	lvl.get_node("players/conplayer").position = GlobalFunctions.string_to_vector2(meta["spawn"]) - Vector2(64, 0)
	lvl.set_meta("palette", meta["palette"]) 
	apply_colors(lvl, lvl.get_meta("palette"))
	lvl.set_meta("bronze_time", meta["medals"][2])
	lvl.set_meta("silver_time", meta["medals"][1])
	lvl.set_meta("gold_time", meta["medals"][0])
	$timers/bronze.wait_time = lvl.get_meta("bronze_time")
	$timers/silver.wait_time = lvl.get_meta("silver_time")
	$timers/gold.wait_time = lvl.get_meta("gold_time")
	ui_handler.fin.connect(fin)
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_restart"):
		if not player.not_finished:
			ui_handler.start.emit()
		self.get_node('level').get_child(0).queue_free()
		$timers/bronze.paused = true
		$timers/silver.paused = true
		$timers/gold.paused = true
		var lvl = level.instantiate()
		$level.add_child(lvl)
		lvl.name = "level"
		player = lvl.get_node("players/player")
		
		read_json(level_json, 1)
		player.position = GlobalFunctions.string_to_vector2(meta["spawn"])  - Vector2(64, 0)
		lvl.get_node("players/conplayer").position = GlobalFunctions.string_to_vector2(meta["spawn"]) - Vector2(64, 0)
		lvl.set_meta("palette", meta["palette"]) 
		started = false
		running = false
		$ui.get_node("medal display").visible = true
		$ui.get_node("medal display").frame = 0
		apply_colors(lvl, lvl.get_meta("palette"))
	if Input.is_action_just_pressed("ui_escape"):
		escape()
	
	if player:
		if player.alive == false:
			$timers/bronze.paused = true
			$timers/silver.paused = true
			$timers/gold.paused = true
			if running:
					
				$ui.particle(3)
			running = false
	if started:
		$ui/Label.text = var_to_str(round_to_dec($timers/bronze.time_left, 1))
		$ui/Label/Label.text ="("+ var_to_str(round_to_dec($timers/bronze.wait_time, 1) - round_to_dec($timers/bronze.time_left, 1)) + ")"
	else:
		$ui/Label.text = var_to_str($timers/bronze.wait_time)
		$ui/Label/Label.text = "(0.0)"
func start(playero:Node) -> void:
	$timers/bronze.start()
	$timers/silver.start()
	$timers/gold.start()
	$timers/bronze.paused = false
	$timers/silver.paused = false
	$timers/gold.paused = false
	player = playero
	started = true
	running = true
func _on_bronze_timeout() -> void:
	player.get_parent().get_node("conplayer").die()
	player.die()
	$timers/bronze.stop()
	$timers/silver.stop()
	$timers/gold.stop()
	$ui.particle(2)
	running = false
func _on_silver_timeout() -> void:
	
	$ui.particle(1)
func _on_gold_timeout() -> void:
	
	$ui.particle(0)
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
func apply_colors(obj, colors) -> void:
	obj.get_node("bg").scale *= 100
	obj.get_node("bg").modulate = Color.from_hsv(colors[1][0],colors[1][1],colors[1][2])
	obj.get_node("players").modulate = Color.from_hsv(colors[0][0],colors[0][1],colors[0][2])
	obj.get_node("blocks").modulate = Color.from_hsv(colors[2][0],colors[2][1],colors[2][2])
func fin():
	$timers/bronze.paused = true
	$timers/silver.paused = true
	$timers/gold.paused = true
	if campaign:
		print("new pb run")
		var lvl_file = FileAccess.open("user://data/campaign_info/"+var_to_str(id)+ ".txt", FileAccess.READ_WRITE)
		var old = JSON.parse_string(lvl_file.get_as_text())
		old["pb"] = float(meta["medals"][2]) - $timers/bronze.time_left if float(meta["medals"][2]) - $timers/bronze.time_left < old["pb"] or old["pb"] == -1 else old["pb"]
		if $timers/gold.time_left > 0:
			old["medal"] = 3
		elif $timers/silver.time_left > 0:
			old["medal"] = 2
		elif $timers/bronze.time_left > 0:
			old["medal"] = 1
		else:
			old["medal"] = 0
		lvl_file.store_string(JSON.stringify(old))
func read_json(stringjs:String, id):
	var data = JSON.parse_string(stringjs)
	var objects = data["objects"]
	meta = data["meta"]
	var pal = meta["palette"]
	print(pal)
	for i in objects:
		var ins = objects_sc[i["object"]].instantiate()
		match i["object"]:
			"block", "spike":
				ins.modulate = Color.from_hsv(pal[2][0], pal[2][1], pal[2][2])
			"fin", "orb":
				ins.modulate = Color.from_hsv(pal[0][0], pal[0][1], pal[0][2])
		ins.position = GlobalFunctions.string_to_vector2(i["position"])
		ins.scale =GlobalFunctions.string_to_vector2(i["scale"])
		ins.rotation_degrees = i["rotation"]
		$level.get_child(id).get_node("obj").add_child(ins)
func escape():
	if $timers/bronze.paused and running:
		self.get_parent().start_black()
		await ui_handler.black_screen

		if self.campaign == true:
			var scene = load("res://campaign_menu.tscn").instantiate()
			self.get_parent().add_child(scene)
			self.queue_free()
		else:
			var scene = load("res://pre_editor.tscn").instantiate()
			self.get_parent().add_child(scene)
			self.queue_free()
	else:
		match menu_switch:
			true:
				menu_switch = false
				ui_handler.settings_open.emit()
				$settings.visible = false
			false:
				menu_switch = true
				ui_handler.settings_closed.emit()
				$settings.visible = true
