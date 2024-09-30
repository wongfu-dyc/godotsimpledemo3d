extends CharacterBody3D

@export var speed = 5
@export var fall_acceleration = 75
var target_velocity = Vector3.ZERO
var mouse_sentitivity : float = 0.01
var twist_input : float = 0.0
var pitch_input : float = 0.0
var cooldown_time = 0.8
var key_pressed = false
@export var camera :Node3D

@onready var animation = $"Viewport/TwistPivot/PitchPivot/3DGodotRobot/AnimationPlayer"
@onready var hitbox = $"Viewport/TwistPivot/HitBox"
func attack():
	var enemies = hitbox.get_overlapping_bodies()
	for enemy in enemies:
		if enemy.has_method("hurt"):
			enemy.hurt() 

func move(delta : float):
	var direction = Vector3.ZERO
	direction.x = Input.get_axis("ui_left","ui_right")
	direction.z = Input.get_axis("ui_up","ui_down")
	if direction != Vector3.ZERO:
		direction = direction.normalized()
	
	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Vertical Velocity
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)
	else:
		target_velocity.y = get_floor_angle()
	
	# Moving the Character
	if direction != Vector3.ZERO:
		$"Viewport/TwistPivot".basis = Basis.looking_at(direction)
	velocity = $Viewport.basis * target_velocity
	#velocity = target_velocity
func anim():	
	if Input.is_action_pressed("ui_up") or  Input.is_action_pressed("ui_down") or  Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		$AnimationTree.set("parameters/conditions/is_walking",true)
		$AnimationTree.set("parameters/conditions/is_idling",false)
	else:
		$AnimationTree.set("parameters/conditions/is_walking",false)
		$AnimationTree.set("parameters/conditions/is_idling",true)
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and not key_pressed and event.is_action_pressed("cam move"):
		key_pressed = true
		get_tree().create_timer(cooldown_time).connect("timeout", _on_cooldown_timeout)
		if event.is_action_pressed("cam right"):
			twist_input += -90
		if event.is_action_pressed("cam left"):
			twist_input += 90
		if event.is_action_pressed("cam back"):
			twist_input += 180
		camera.yaw_root = twist_input
	if event is InputEventKey:
		if event.keycode == KEY_E:
			setStateAttack(	)
		
func setStateAttack():
	animation.play("Attack1",0.05)
	attack()
	
func _on_cooldown_timeout():
	key_pressed = false
func _physics_process(delta: float) -> void:		
	$Viewport.rotation_degrees.y = lerp($Viewport.rotation_degrees.y,twist_input,0.2)
	move(delta)
	anim()
	#twist_input = 0.0
	#pitch_input = 0.0
	move_and_slide()
