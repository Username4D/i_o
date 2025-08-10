extends Node2D

func _process(delta: float) -> void:
	if $Timer.time_left > 1.5:
		$Sprite2D.modulate.a = 1.0 - ($Timer.time_left - 1.5)
	elif $Timer.time_left < 1.0:
		$Sprite2D.modulate.a =$Timer.time_left
	elif $Timer.time_left > 0.9:
		$Sprite2D.modulate.a = 1.0
	else:
		$Sprite2D.modulate.a = 0.0



func _on_timer_timeout() -> void:
	var scene = load("res://global_view.tscn").instantiate()
	self.get_parent().add_child(scene)
	self.reparent(scene)
	scene.start_black()
	await ui_handler.black_screen
	self.queue_free()
