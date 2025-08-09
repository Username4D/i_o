extends Area2D
@export var finished = false


func _physics_process(delta: float) -> void:
	$Fin.rotation_degrees += 1

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.fin()
		ui_handler.fin.emit()
		finished = true
