extends Node2D
var fin: Node
func update_text_typewrite(txt: String, fast: bool = false) -> void:
	$text_box/text.text = ""
	for i in txt:
		if Input.is_mouse_button_pressed( 1 ):
			$text_box/text.text = txt
			break
		$text_box/text.text += i
		if not fast:
			await get_tree().process_frame
			await get_tree().process_frame
		await get_tree().process_frame
func _ready() -> void:
	disable_esc()
	disable_lr_jump()
	await tutorial_step(0, $text_box/continue, $text_box/continue.pressed)
	await tutorial_step(1, $global_view/main_menu/buttons/play, $global_view/main_menu/buttons/play.pressed)
	await ui_handler.black_screen
	await tutorial_step(2, $global_view/campaign/buttons/button/Button, $global_view/campaign/buttons/button/Button.pressed)
	await get_tree().process_frame
	$text_box.position.y += 96
	await tutorial_step_fin(3)
	renable_esc()
	await update_text_typewrite("Great! Now head back to the main menu.", true)
	disable_lr_jump()
	await ui_handler.black_screen
	$text_box.position.y += -96
	await ui_handler.black_screen
	disable_esc()
	await get_tree().process_frame
	await tutorial_step(4, $global_view/main_menu/buttons/editor, $global_view/main_menu/buttons/editor.pressed)
	await ui_handler.black_screen
	await get_tree().process_frame
	await tutorial_step(5, $global_view/pre_editor/Button, $global_view/pre_editor/Button.pressed)
	await  ui_handler.black_screen
	$focus.scale.x = 50
	$focus.scale.y = 2
	$focus.modulate.a = 1
	$focus.position = Vector2(0, 576 + 8)
	await tutorial_step(6, $text_box/continue, $text_box/continue.pressed)
	$focus.scale.y = 1.5
	$focus.scale.x = 6
	$focus.modulate.a = 1
	$focus.position = Vector2(912, 48)
	await tutorial_step(7, $text_box/continue, $text_box/continue.pressed)
	$focus.scale.y = 1.5
	$focus.scale.x = 4
	$focus.modulate.a = 1
	$focus.position = Vector2(912 - 576 - 128 - 64, 48)
	await tutorial_step(8, $text_box/continue, $text_box/continue.pressed)
	renable_lr_jump()
	renable_esc()
	var gl = load("res://global_view.tscn").instantiate()
	gl.get_node("main_menu").queue_free()
	$global_view/editor.reparent(gl)
	self.get_parent().add_child(gl)
	self.queue_free()
	
var stats = [
	{"use_continue": true, "pos": Vector2(0,0), "fscale": 1, "awaiting signal": null, "text": "Welcome to the tutorial: Dont worry, this is just a quick introduction to show you the game."},
	{"use_continue": false, "pos": Vector2(576,320), "fscale": 1.5, "awaiting signal": null, "text": "Start by pressing play to head into the level selection. You can always go back using esc or Y."},
	{"use_continue": false, "pos": Vector2(576,320), "fscale": 2.5, "awaiting signal": null, "text": "This is your campaign menu, in which you can see your unlocked levels and pbs. You can navigate using left/right. Now head into the first level."},
	{"use_continue": false, "pos": Vector2(576,320), "fscale": 30, "awaiting signal": null, "text": "Welcome to the first very exciting level: What you can see to your left is the finish, try to get there as fast as possible. If you want to restart press r or B."},
	{"use_continue": false, "pos": Vector2(800,320), "fscale": 1.5, "awaiting signal": null, "text": "We'll now take a look at the editor. Go ahead and press the editor button. WARNING: Since the editor is way to complex it doesnt have full Controller support. But dont worry, you can finish the tutorial with controller."},
	{"use_continue": false, "pos": Vector2(1088,64), "fscale": 1.5, "awaiting signal": null, "text": "Press new to create a new level. In Future your past levels will also appear here."},
	{"use_continue": true, "pos": Vector2(0,0), "fscale": 1, "awaiting signal": null, "text": "This is your editor: On the bottom of your screen you can see the blocks you can place, sorted into three categories. To create one of them just click on them"},
	{"use_continue": true, "pos": Vector2(0,0), "fscale": 1, "awaiting signal": null, "text": "On the top right you can see your tools. You can also select them using 1 - 4"},
	{"use_continue": true, "pos": Vector2(0,0), "fscale": 1, "awaiting signal": null, "text": "On the top left you can see your settings and a save button. Thats all for this tutorial, go have fun and explore!"}
]

func tutorial_step(n: int, focus: Node, signa: Signal):
	$block.visible = true
	$text_box/continue.visible = false
	var use_c = stats[n]["use_continue"]
	var fscale = stats[n]["fscale"]
	var text = stats[n]["text"]
	var pos = stats[n]["pos"]
	if n == 3:
		await update_text_typewrite(text, true)
	else:
		await update_text_typewrite(text)
	if use_c:
		$text_box/continue.visible = true
		await $text_box/continue.pressed
		$text_box/continue.grab_focus()
	else:
		$focus.position = pos
		$focus.scale = Vector2(fscale * 2, fscale * 2)
		focus.grab_focus()
		$block.visible = false
		$focus.modulate.a = 1
		await signa
	$block.visible = true
	$text_box/continue.visible = false
	$focus.modulate.a = 0
	
func tutorial_step_fin(n: int):
	$block.visible = true
	$text_box/continue.visible = false
	var use_c = stats[n]["use_continue"]
	var fscale = stats[n]["fscale"]
	var text = stats[n]["text"]
	var pos = stats[n]["pos"]
	await update_text_typewrite(text)
	renable_lr_jump()
	if use_c:
		$text_box/continue.visible = true
		await $text_box/continue.pressed
		$text_box/continue.grab_focus()
	else:
		$focus.position = pos
		$focus.scale = Vector2(fscale * 2, fscale * 2)
		$block.visible = false
		$focus.modulate.a = 1
		while not $global_view/level_viewport/level.get_child(0).get_node("obj/fin").finished:
			await get_tree().process_frame
	$block.visible = true
	$text_box/continue.visible = false
	$focus.modulate.a = 0

var jump_input_events
var lrj = {}
func disable_esc(): 
	jump_input_events = InputMap.action_get_events("ui_escape") 
	InputMap.action_erase_events("ui_escape")

func renable_esc(): 
	for input_event in jump_input_events: 
		InputMap.action_add_event("ui_escape", input_event)

func disable_lr_jump(): 
	lrj["left"] = InputMap.action_get_events("ui_left") 
	InputMap.action_erase_events("ui_left")
	lrj["right"] = InputMap.action_get_events("ui_right") 
	InputMap.action_erase_events("ui_right")
	lrj["jump"] = InputMap.action_get_events("ui_jump") 
	InputMap.action_erase_events("ui_jump")
func renable_lr_jump(): 
	for input_event in lrj["left"]: 
		InputMap.action_add_event("ui_left", input_event)
	for input_event in lrj["right"]: 
		InputMap.action_add_event("ui_right", input_event)
	for input_event in lrj["jump"]: 
		InputMap.action_add_event("ui_jump", input_event)
