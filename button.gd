extends Node2D

@export var lname: String
@export var pb: String
@export var medal: int
@export var json: String
func init() -> void:
	await get_tree().process_frame
	if medal == 0:
		$Sprite2D.visible = false
	else:
		$Sprite2D.texture.region = Rect2((medal - 1) * 96, 0, 96, 96)
	$time.text = pb
	$name.text = lname
	
func _on_button_pressed() -> void:
	get_parent().get_parent().play(json)
