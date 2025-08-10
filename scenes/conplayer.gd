extends Area2D

@onready var player = self.get_parent().get_node("player")
var killing = false
func _physics_process(delta: float) -> void:
	if player.con_active:
		$Polygon2D.visible = true
	else:
		$Polygon2D.visible = false
	for i in get_overlapping_bodies():
		if i.is_in_group("player") and killing:
			i.die()
			print("died to playerrr")
			$GPUParticles2D.emitting = true
			$Polygon2D.visible = false
	if player.con_active and len(player.positions) >= 30:
		killing = true
		self.position = player.positions[0]
		player.positions.remove_at(0)
		self_modulate.a = 1
	elif player.con_active:
		self.self_modulate.a = 0.033* len(player.positions)
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and killing:
		body.die()

func die():
	$GPUParticles2D.emitting = true
	$Polygon2D.visible = false
	killing = false
