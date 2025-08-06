extends ColorRect

var clicked = false
@export var lname = ""

func _ready() -> void:
	$name.text = lname
func _on_button_button_down() -> void:
	if clicked:
		self.get_parent().get_parent().get_parent().load_editor(lname)
	else:
		clicked = true
	$play.visible = true
	$delete.visible = true
func _on_button_focus_exited() -> void:
	await get_tree().process_frame
	
	if not $play.has_focus() and not $delete.has_focus() and not self.has_focus():
		$play.visible = false
		$delete.visible = false
		clicked = false
func grab():
	$Button.grab_focus()
func _on_button_focus_entered() -> void:
	await get_tree().process_frame
	print(self.global_position)
	if self.global_position.y < 180:
		self.get_parent().get_parent().scroll_vertical -= 80
	if self.global_position.y > 520:
		self.get_parent().get_parent().scroll_vertical += 80
func _on_play_pressed() -> void:
	self.get_parent().get_parent().get_parent().play(lname)
