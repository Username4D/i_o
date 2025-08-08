extends Node2D

@export var obj: String
@export var rot = 0
var scale_type = "tile"



func _process(delta: float) -> void:
	match self.get_parent().mode:
		"move":
			if $Button.button_pressed:
				self.position = GlobalFunctions.snap_position(get_viewport().get_mouse_position(), true, position, scale)

	if $Button.button_pressed:
		$Sprite2D.modulate = Color.from_rgba8(0.8 * 255,0.8 * 255,0.8 * 255,255)
	else:
		$Sprite2D.modulate = Color.from_rgba8(1 * 255,1 * 255,1 * 255,255)
		
		
