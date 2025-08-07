extends TextureRect

var spikes = []
var pikes = []
var sizes = Vector2.ONE

@onready var rot = 0
func _ready() -> void:
	
	await get_tree().process_frame
	self.material.set_shader_parameter("tint", Vector4(self.get_parent().modulate.r, self.get_parent().modulate.g,self.get_parent().modulate.b, self.get_parent().modulate.a))
	rot = get_parent().rotation_degrees
	get_parent().rotation_degrees = 0
	print(rot)
	sizes = abs(self.get_parent().scale)
	$"../CollisionPolygon2D".position -= Vector2((sizes.x - 1 )/ 2 * 32, (sizes.y - 1 )/ 2 * 32)
	material.set_shader_parameter("regionPosition", Vector2(rot / 90.0 * 128.0, 0))
	$"../CollisionPolygon2D".rotation_degrees = rot
	self.scale = sizes / 4
	material.set_shader_parameter("scale", scale * 4)
	self.get_parent().scale = Vector2.ONE
	for i in range(0, sizes.x):
		var spike = get_parent().get_node("CollisionPolygon2D").duplicate()
		spike.position.x += (i) * 32
		spike.name = "wow"
		self.get_parent().add_child(spike)
		spikes.append(spike)
	for i in range(1, sizes.y):
		for n in spikes:
			var spike = n.duplicate()
			spike.position.y += (i) * 32
			self.get_parent().add_child(spike)
			pikes.append(spike)
	

	$"../CollisionPolygon2D".queue_free()
	#$"..".position.x -= (sizes.x - 1) * 16
	#$"..".position.y -= (sizes.y - 1) * 16
	#self.rotation_degrees = rot

func _on_spike_body_entered(body: Node2D) -> void:
	if body.is_in_group('player'):
		body.get_parent().get_node("conplayer").die()
		body.die()
