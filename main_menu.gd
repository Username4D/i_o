extends Node2D

var s = 0
var first = true
func transition(scene: String):
	var nscene: PackedScene
	match scene:
		"play":
			nscene = load("res://campaign_menu.tscn")
		"settings":
			nscene = load("res://pre_editor.tscn")
		"editor":
			nscene = load("res://pre_editor.tscn")
	self.get_parent().start_black()
	await ui_handler.black_screen
	var obj = nscene.instantiate()
	self.get_parent().add_child(obj)
	self.queue_free()
func _ready() -> void:
	for i in $buttons.get_children():
		i.pressed.connect(transition.bind(i.name))
func _process(delta: float) -> void:
	$Label.position.y = -64 + sin(s) * 16
	s += 0.01
	if s >= 6.28:
		s = 0

func _input(event: InputEvent) -> void:
	if (event is InputEventJoypadButton) or (event is InputEventJoypadMotion):
		if event is InputEventJoypadMotion:
			if first and event["axis_value"] != 0.0:
				$buttons/play.grab_focus()
				first = false
		else:
			if first:
				$buttons/play.grab_focus()
				first = false
