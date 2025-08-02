extends Node2D

var level = preload("res://scenes/test_scene.tscn")
var player: Node
@export var started = false
@export var running = false
@export var level_json = ""
@onready var objects_sc = {"block": preload("res://scenes/block.tscn"), "spike": preload("res://scenes/spike.tscn"), "orb": preload("res://scenes/orb.tscn"), "fin": preload("res://scenes/fin.tscn")}
func _ready() -> void:
	var lvl = level.instantiate()
	lvl.name = "level"
	$timers/bronze.wait_time = lvl.get_meta("bronze_time")
	$timers/silver.wait_time = lvl.get_meta("silver_time")
	$timers/gold.wait_time = lvl.get_meta("gold_time")
	player = lvl.get_node("players/player")
	$level.add_child(lvl)
	read_json(level_json)
	apply_colors(lvl, lvl.get_meta("palette"))
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
		started = false
		running = false
		$ui.get_node("medal display").visible = true
		$ui.get_node("medal display").frame = 0
		apply_colors(lvl, lvl.get_meta("palette"))
		
	
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
	else:
		$ui/Label.text = var_to_str($timers/bronze.wait_time)
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
	obj.get_node("bg").modulate = colors[1]
	obj.get_node("blocks").modulate = colors[2]
	obj.get_node("players").modulate = colors[0]
	obj.get_node("foreground").modulate = colors[3]
func fin():
	$timers/bronze.paused = true
	$timers/silver.paused = true
	$timers/gold.paused = true
func read_json(stringjs:String):
	var data = JSON.parse_string(stringjs)
	print(data)
	var objects = data["objects"]
	for i in objects:
		var ins = objects_sc[i["object"]].instantiate()
		ins.position = GlobalFunctions.string_to_vector2(i["position"])
		ins.scale =GlobalFunctions.string_to_vector2(i["scale"])
		ins.rotation_degrees = i["rotation"]
		$level.get_node("level").get_node("obj").add_child(ins)
	
