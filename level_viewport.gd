extends Node2D

var level = preload("res://scenes/test_scene.tscn")

func _ready() -> void:
	var lvl = level.instantiate()
	lvl.name = "level"
	$level.add_child(lvl)
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_restart"):
		self.get_node('level').get_child(0).queue_free()
		var lvl = level.instantiate()
		$level.add_child(lvl)
		lvl.name = "level"
