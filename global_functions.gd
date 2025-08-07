extends Node

func name_to_sprite_id(name):
	match name:
		"block":
			return 0
		"spike":
			return 1
		"orb":
			return 2
		"fin":
			return 3
func snap_position(position:Vector2, check_bounds: bool, fallback: Vector2, scale: Vector2) -> Vector2:
	if check_bounds:
		var returns = Vector2(round((position.x - 16) / 32) * 32 + 16, round((position.y - 16) / 32) * 32 + 16)
		scale = abs(scale)
		if not 32 < returns.x - 16 * scale.x or not returns.x - 16 * scale.x < 1088 - 32 * scale.x :
			if not 32 < returns.x - 16 * scale.x:
				returns.x = 64 + 16 * scale.x
			else:
				returns.x = 1088 - 16 * scale.x
		if not 95 < returns.y - 16 * scale.y or not returns.y - 16 * scale.y < 544 - 32 * scale.y:
			if not 95 < returns.y - 16 * scale.y :
				returns.y = 96 + 16 * scale.y
			else:
				returns.y = 544 - 16 * scale.y
		return returns
	else:
		return Vector2(round((position.x - 16) / 32) * 32 + 16, round((position.y - 16) / 32) * 32 + 16)
func snap_scale(scale: Vector2) -> Vector2:
	return Vector2(round(scale.x / 32) * 2 + 1, round((scale.y) / 32) * 2 + 1)
func check_scale(position:Vector2, scale: Vector2) -> bool:

	var returns = true
	scale = abs(scale)
	if not 32 < position.x - 16 * scale.x or not position.x - 16 * scale.x < 1089 - 32 * scale.x :
		if not 32 < position.x - 16 * scale.x:
			returns = false
		else:
			returns = false
	if not 95 < position.y - 16 * scale.y or not position.y - 16 * scale.y < 545 - 32 * scale.y:
		if not 95 < position.y - 16 * scale.y :
			returns = false
		else:
			returns = false
	return returns
func easeInOutQuad(x) -> float:
	return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2
func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string = new_string.erase(0, 1)
		new_string = new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")

		return Vector2(int(array[0]), int(array[1]))

	return Vector2.ZERO
func parse_str_to_color(c: String):
	c = c.erase(0,1)
	c = c.erase(len(c) - 1, 1)
	var a = c.split(",")
	print([float(a[0]), float(a[1]), float(a[2]), float(a[3])])
	return [float(a[0]), float(a[1]), float(a[2]), float(a[3])]
