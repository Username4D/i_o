extends Node2D

@export var lname: String
@export var pb: float
@export var medal: int
@export var json: String
@export var id: int
@export var unlocked = true
func init() -> void:
	if not unlocked:
		self.modulate = Color8(200,200,200,255)
	await get_tree().process_frame
	if medal == 0:
		$Sprite2D.visible = false
	else:
		$Sprite2D.texture.region = Rect2((3-medal) * 96, 0, 96, 96)
	if pb != -1:
		$time.text = var_to_str(round_to_dec(pb, 1))
	else:
		$time.text = "none"
	$name.text = lname
	
func _on_button_pressed() -> void:
	if unlocked:
		get_parent().get_parent().play(json, id)
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_left") and self.get_parent().get_parent().cleft:
		move(-1)
	if Input.is_action_just_pressed("ui_right") and self.get_parent().get_parent().cright:
		move(1)
func move(direction: int):
	await get_tree().process_frame
	var new_offset = 0
	var old_offset = 0
	for i in range(0.0, 41.0):
		new_offset = GlobalFunctions.easeInOutQuad(i / 40.0) * 576 * direction
		self.position.x -= new_offset - old_offset
		old_offset = new_offset
		await get_tree().process_frame
		
func round_to_dec(num, digit):
	return round(num * pow(10.0, digit)) / pow(10.0, digit)
