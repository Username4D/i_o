extends Area2D

var used = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not used:
		body.touching_orb = true
		body.orb = self

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.touching_orb = false

func use():
	used = true
	$active.visible = false
	$off.visible = true
