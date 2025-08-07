extends Node2D

@export var color: Array

func _process(delta: float) -> void:
	$hue2/MeshInstance2D.texture.gradient.colors[1] = Color.from_hsv($hue.value, 1, 1)
	$hue3/MeshInstance2D.texture.gradient.colors[1] = Color.from_hsv($hue.value, $hue2.value, 1)
	$MeshInstance2D.modulate = Color.from_hsv($hue.value, $hue2.value, $hue3.value)
	color = [$hue.value, $hue2.value, $hue3.value]
func init(c: Color):
	$hue.value = c.h
	$hue2.value = c.s
	$hue3.value = c.v
