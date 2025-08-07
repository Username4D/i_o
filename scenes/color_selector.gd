extends Node2D

@export var color: Color

func _process(delta: float) -> void:
	$hue2/MeshInstance2D.texture.gradient.colors[1] = Color.from_hsv($hue.value, 1, 1)
	$hue3/MeshInstance2D.texture.gradient.colors[1] = Color.from_hsv($hue.value, $hue2.value, 1)
	$MeshInstance2D.modulate = Color.from_hsv($hue.value, $hue2.value, $hue3.value)
	color = Color.from_hsv($hue.value, $hue2.value, $hue3.value)
