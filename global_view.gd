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
		first_boot = FileAccess.open("user://lol.dat", FileAccess.WRITE)
		first_boot.store_string("no")
		
