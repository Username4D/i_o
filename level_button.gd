extends ColorRect

var clicked = false
@export var lname = ""

func _ready() -> void:
	$name.text = lname
	var last = JSON.parse_string(load_lfrom_file(lname))["meta"]["last_edit"]
	var text = Time.get_datetime_string_from_datetime_dict(last, false)
	text = text.split("T")[0]
	$date.text = "last edited: " + text
	print(last)
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
func load_lfrom_file(fname):
	var file = FileAccess.open("user://" + fname + ".txt", FileAccess.READ)
	var content = file.get_as_text()
	return content
func _on_delete_pressed() -> void:
	self.get_parent().get_parent().get_parent().delete(lname, self)
