extends Node2D

# display down
var current_display = "blocks"
var editor_obj = preload("res://scenes/editor_obj.tscn")

# general
@export var mode = "none"

# settings
var settings_open = true

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
	for i in range(0.0, 20.0,1.0):
		$settings.offset.y = 648 * GlobalFunctions.easeInOutQuad(1 -(i / 20.0)) if settings_open else 648 * GlobalFunctions.easeInOutQuad( i / 20.0)
		$ColorRect.material.set_shader_parameter("blur_strength", i /10 + 0.1 if  settings_open else 1 - i / 10 + 0.1)
		await get_tree().process_frame
		await get_tree().process_frame
		
	
	settings_open = false if settings_open else true
func save():
	var objects = []
	for i in $level.get_children():
		objects.append({"position": i.position, "scale": i.scale, "object": i.obj, "rotation": i.rot})
	var meta = {"name": $settings.level_name, "medals": $settings.medals}
	var level = {"objects": objects, "meta": meta}
	
	
	var json = JSON.stringify(level, "\t")
	print(json)
