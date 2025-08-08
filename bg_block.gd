extends Node2D

@export var obj: Node
@export var pallette: Array

func _process(delta: float) -> void:
	if obj:
		self.position.x = (obj.position.x - 576) * 2
		self.visible = true
	if pallette:
		$wall.modulate = Color.from_hsv(pallette[2][0],pallette[2][1],pallette[2][2])
		$bg.modulate = Color.from_hsv(pallette[1][0],pallette[1][1],pallette[1][2])
