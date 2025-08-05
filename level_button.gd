extends Node2D

var clicked = false
@export var lname = ""
var subfocus = false
func _ready() -> void:
	$name.text = lname
func _on_button_button_down() -> void:
	if clicked:
		self.get_parent().get_parent().load_editor(lname)
	else:
		clicked = true
	$Button/play.visible = true
	$Button/delete.visible = true
	
func _on_button_focus_exited() -> void:
	await get_tree().process_frame
	clicked = false
	if not subfocus:
		$Button/play.visible = false
		$Button/delete.visible = false
	

func _on_play_pressed() -> void:
	self.get_parent().get_parent().play(lname)
	subfocus = false


func _on_play_button_down() -> void:
	subfocus = true
