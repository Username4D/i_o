extends TextureRect

func _ready() -> void:
	for i in range(0, size.x / 128 - 1):
		var spike = $spike/CollisionPolygon2D.duplicate()
		spike.position.x = (i + 1) * 128
		$spike.add_child(spike)
		



func _on_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.get_parent().get_node("conplayer").die()
		body.die()
