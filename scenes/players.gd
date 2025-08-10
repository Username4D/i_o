extends CharacterBody2D

# Character Stats/Variables

var speed = 0
var accel = 4
var friction = 30
var max_speed = 270

var jump_strength = -240
var gravity = 6

# conplayer tracking

@export var positions = []
@export var con_active = false

# player status

@export var alive = true

# orb interaction

@export var touching_orb = false
@export var orb: Node
@export var not_finished = true
func _physics_process(delta: float) -> void:
	
		
	if Input.get_axis("ui_left", "ui_right")  != 0 and accel != 0 and alive and not_finished:
		if con_active == false:
			positions.clear()
			
			con_active = true
			self.get_parent().get_parent().get_parent().get_parent().start(self)
		if speed != 0:
			if Input.get_axis("ui_left", "ui_right") / abs(Input.get_axis("ui_left", "ui_right")) != speed/abs(speed):
				if is_on_floor():
					speed = move_toward(speed, Input.get_axis("ui_left", "ui_right") / abs(Input.get_axis("ui_left", "ui_right")) * max_speed, friction)
				else:
					speed = move_toward(speed, Input.get_axis("ui_left", "ui_right") / abs(Input.get_axis("ui_left", "ui_right")) * max_speed, friction / 3)
			else:
				speed = move_toward(speed, Input.get_axis("ui_left", "ui_right") / abs(Input.get_axis("ui_left", "ui_right")) * max_speed, accel)
		else:
			speed = move_toward(speed, Input.get_axis("ui_left", "ui_right") / abs(Input.get_axis("ui_left", "ui_right")) * max_speed, accel)
			
	else:
		speed = move_toward(speed, 0, friction / 2)
	if is_on_wall_only() and Input.get_axis("ui_left", "ui_right")  != 0 and velocity.y > 0:
		gravity = 3
	else:
		gravity = 6
	velocity.x = speed
	velocity.y += gravity
	if Input.is_action_pressed("ui_jump") and is_on_floor() and alive:
		
		velocity.y = jump_strength
		if con_active == false and not_finished:
			positions.clear()
			self.get_parent().get_parent().get_parent().get_parent().start(self)
			con_active = true
	if Input.is_action_just_pressed("ui_jump") and is_on_wall_only() and alive:
		velocity.y = jump_strength
		speed *= -1
		if con_active == false and not_finished:
			self.get_parent().get_parent().get_parent().get_parent().start(self)
			positions.clear()
			con_active = true
	if Input.is_action_just_pressed("ui_jump") and touching_orb:
		velocity.y = jump_strength
		orb.use()
	if Input.is_action_pressed("ui_jump") and alive and not_finished:
		if con_active == false:
			positions.clear()
			self.get_parent().get_parent().get_parent().get_parent().start(self)
			con_active = true
	if  not con_active :

		velocity = Vector2.ZERO
	move_and_slide()
	positions.append(self.position)
	
	
func die() -> void:
	alive = false
	$MeshInstance2D.visible = false
	$GPUParticles2D.emitting = true
	gravity = 0
	speed = 0
	accel = 0
	velocity = Vector2.ZERO
	friction = 0
	jump_strength = 0
	con_active = false

func fin():
	self.get_parent().get_node("conplayer").die()
	not_finished = false
	gravity = 0 
	con_active = false
