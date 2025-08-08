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
