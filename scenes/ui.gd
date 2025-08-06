extends CanvasLayer

@onready var bronze = self.get_parent().get_node("timers").get_node("bronze")
@onready var silver = self.get_parent().get_node("timers").get_node("silver")
@onready var gold = self.get_parent().get_node("timers").get_node("gold")

@onready var timers = [gold,silver,bronze]

@export var tracking = 0
var tracking_on_death = 0

func _process(delta: float) -> void:
	if get_parent().running:
		$"medal display".visible = true
		tracking_on_death = tracking
	if self.get_parent().running and not timers[tracking].time_left > 0:
		if tracking != 2:
			
			tracking += 1
		else:
			
			tracking = 0 
	
	if not get_parent().running:
		tracking = 0
	else:
		$"medal display".frame = tracking
func particle(i):
	$GPUParticles2D.restart()
	$right.restart()
	match i:
		0:
			$GPUParticles2D.process_material.anim_offset_max = 0
			$GPUParticles2D.process_material.anim_offset_min = 0
		2:
			$GPUParticles2D.process_material.anim_offset_max = 0.67
			$GPUParticles2D.process_material.anim_offset_min = 0.67
			$"medal display".visible = false
		1:
			$GPUParticles2D.process_material.anim_offset_max = 0.35
			$GPUParticles2D.process_material.anim_offset_min = 0.35
		3:
			match tracking_on_death:
				0:
					$GPUParticles2D.process_material.anim_offset_max = 0
					$GPUParticles2D.process_material.anim_offset_min = 0
				2:
					$GPUParticles2D.process_material.anim_offset_max = 0.67
					$GPUParticles2D.process_material.anim_offset_min = 0.67
				1:
					$GPUParticles2D.process_material.anim_offset_max = 0.35
					$GPUParticles2D.process_material.anim_offset_min = 0.35
			
			$"medal display".visible = false
	match i:
		0:
			$right.process_material.anim_offset_max = 0.30
			$right.process_material.anim_offset_min = 0.30
		2:
			$right.process_material.anim_offset_max = 1
			$right.process_material.anim_offset_min = 1
		1:
			$right.process_material.anim_offset_max = 0.6
			$right.process_material.anim_offset_min = 0.6
		3:
			match tracking_on_death:
				0:
					$right.process_material.anim_offset_max = 0.30
					$right.process_material.anim_offset_min = 0.30
				2:
					$right.process_material.anim_offset_max = 1
					$right.process_material.anim_offset_min = 1
				1:
					$right.process_material.anim_offset_max = 0.60
					$right.process_material.anim_offset_min = 0.60
			
	$right.emitting = true
	
	$GPUParticles2D.emitting = true
func _ready() -> void:
	ui_handler.fin.connect(transition_end.bind(false))
	ui_handler.start.connect(transition_start.bind(false))
	ui_handler.settings_open.connect(transition_start.bind(true))
	ui_handler.settings_closed.connect(transition_end.bind(true))
func transition_end(sf: bool):
	if self.get_parent().get_node("level").get_child(0):
		
		print("lol")
		for i in range(10, 50, 2):
			self.get_parent().get_node("level").get_child(0).get_node("ColorRect").material.set_shader_parameter("blur_strength", i / 10)
			if not sf:
				$Label.position.y =easeInOutQuad(float(i - 11) / 40) * 224
				$"medal display".position.y = 592 - easeInOutQuad(float(i - 11) / 40) * 224
			else:
				$ColorRect.material.set_shader_parameter("blur_strength", i / 10)
			
			await get_tree().process_frame

func transition_start(sf: bool):
	if self.get_parent().get_node("level").get_child(0):
		
		print("lol")
		for i in range(10, 50, 2):
			self.get_parent().get_node("level").get_child(0).get_node("ColorRect").material.set_shader_parameter("blur_strength", 4.01 - i / 10)
			if not sf:
				$Label.position.y = 224 - easeInOutQuad(float(i - 11) / 40) * 224
				$"medal display".position.y = 368 + easeInOutQuad(float(i - 11) / 40) * 224
			else:
				$ColorRect.material.set_shader_parameter("blur_strength", 4.01 - i / 10)
			
			await get_tree().process_frame
func easeInOutQuad(x) -> float:
	return 2 * x * x if x < 0.5 else 1 - pow(-2 * x + 2, 2) / 2
