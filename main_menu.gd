extends Node2D

var s = 0

func transition(scene: String):
	var nscene: PackedScene
	match scene:
		"play":
			nscene = load("res://campaign_menu.tscn")
		"settings":
			nscene = load("res://pre_editor.tscn")
		"editor":
			nscene = load("res://pre_editor.tscn")
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
