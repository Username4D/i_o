extends Node2D

func start_black():
	for i in range(0.0, 21.0):
		$ColorRect.modulate.a = i / 20.0
		await get_tree().process_frame
	ui_handler.black_screen.emit()
	await get_tree().process_frame
	for i in range(0.0, 21.0):
		$ColorRect.modulate.a =1.0 -  i / 20.0
		await get_tree().process_frame
func _ready() -> void:
	print(OS.is_userfs_persistent())
	var first_boot = FileAccess.open("user://lol.dat", FileAccess.READ)
	if first_boot == null:
		var user_dir = DirAccess.open("user://")
		user_dir.make_dir("data")
		DirAccess.make_dir_absolute("user://data/campaign_info")
		for i in range(1, 6):
			var file = FileAccess.open("user://data/campaign_info/" + var_to_str(i) + ".txt" , FileAccess.WRITE)
			file.store_string(JSON.stringify({"medal":0,"pb":-1,"unlocked":true}))
		var file = FileAccess.open("user://data/levels.txt", FileAccess.WRITE)
		file.store_string(JSON.stringify([]))
		var l = FileAccess.open("user://data/settings.txt", FileAccess.WRITE)
		var dicddt = {"vsync": false, "max_fps": 240}
		print(JSON.stringify("looo"))
		l.store_string(JSON.stringify(dicddt))
		first_boot = FileAccess.open("user://lol.dat", FileAccess.WRITE)
		first_boot.store_string("no")
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		Engine.max_fps = int(240)
		await get_tree().process_frame
		var popup = load("res://tutorial_popup.tscn").instantiate()
		self.add_child(popup)
		await popup.lol
		await get_tree().process_frame
		if popup.out == "save":
			var tut = load("res://tutorial.tscn").instantiate()
			self.get_parent().add_child(tut)
			self.queue_free()
		else:
			popup.queue_free()
	else:
		var load = FileAccess.open("user://data/settings.txt", FileAccess.READ)
		var sett = JSON.parse_string(load.get_as_text())
		if sett["vsync"]:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		else:
			DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
			Engine.max_fps = int(sett["max_fps"])
