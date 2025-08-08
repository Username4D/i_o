extends Node2D

@export var obj: String
@export var rot = 0
var scale_type = "tile"
func init():
	$TextureRect.texture.region = Rect2(GlobalFunctions.name_to_sprite_id(obj) * 32, 0, 32,32)
	$TextureRect.material.set_shader_parameter("scale", scale)
	$TextureRect.material.set_shader_parameter("regionPosition",Vector2( GlobalFunctions.name_to_sprite_id(obj) * 32, 0 ))
	match obj:
		"block":
			scale_type = "tile"
			$TextureRect.material.set_shader_parameter("regionSize", Vector2(31, 31))
		"spike":
			scale_type = "tile"
		"orb":
			scale_type = "stretch"
		"fin":
			scale_type = "stretch"
func _process(delta: float) -> void:
	match self.get_parent().get_parent().mode:
		"move":
			if $Button.button_pressed:
				self.position = GlobalFunctions.snap_position(get_viewport().get_mouse_position(), true, position, scale)
				
		"scale":
			if $Button.button_pressed:
				if GlobalFunctions.check_scale(position, Vector2(GlobalFunctions.snap_scale(position - get_viewport().get_mouse_position()).x, scale.y)):
					self.scale.x = GlobalFunctions.snap_scale(position - get_viewport().get_mouse_position()).x
				if GlobalFunctions.check_scale(position, Vector2(scale.x, GlobalFunctions.snap_scale(position - get_viewport().get_mouse_position()).y)):
					self.scale.y = GlobalFunctions.snap_scale(position - get_viewport().get_mouse_position()).y
				if scale_type == "tile":
					if $TextureRect.rotation_degrees == 90 or $TextureRect.rotation_degrees == 270:
						$TextureRect.material.set_shader_parameter("scale", Vector2(scale.y, scale.x))
					else:
						$TextureRect.material.set_shader_parameter("scale", Vector2(scale.x, scale.y))
		"delete":
			if $Button.button_pressed:
				self.queue_free()
	if $Button.button_pressed:
		$TextureRect.material.set_shader_parameter("tint", Vector4(0.8, 0.8, 0.8, 1))

		
func tint():
	$TextureRect.material.set_shader_parameter("tint", Vector4(0.8, 0.8, 0.8, 1))
func untint():
	$TextureRect.material.set_shader_parameter("tint", Vector4(1, 1,1, 1))
func _on_button_button_down() -> void:
	if self.get_parent().get_parent().mode == "rotate":
		$TextureRect.rotation_degrees += 90
		$TextureRect.rotation_degrees = 0 if $TextureRect.rotation_degrees == 360 else $TextureRect.rotation_degrees
		rot = $TextureRect.rotation_degrees
		print($TextureRect.rotation_degrees)
		if scale_type == "tile":
			if $TextureRect.rotation_degrees == 90 or $TextureRect.rotation_degrees == 270:
				$TextureRect.material.set_shader_parameter("scale", Vector2(scale.y, scale.x))
				
			else:
				$TextureRect.material.set_shader_parameter("scale", Vector2(scale.x, scale.y))

func ldinit():
	$TextureRect.rotation_degrees = rot
	if scale_type == "tile":
		if $TextureRect.rotation_degrees == 90 or $TextureRect.rotation_degrees == 270:
			$TextureRect.material.set_shader_parameter("scale", Vector2(scale.y, scale.x))
				
		else:
			$TextureRect.material.set_shader_parameter("scale", Vector2(scale.x, scale.y))


func _on_button_button_up() -> void:
	$TextureRect.material.set_shader_parameter("tint", Vector4(1, 1,1, 1))
