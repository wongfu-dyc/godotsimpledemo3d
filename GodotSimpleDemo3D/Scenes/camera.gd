extends Node3D

@onready var yaw_node = $CamYaw
@onready var pitch_node = $CamYaw/CamPitch
@onready var camera = $CamYaw/CamPitch/Camera3D
@export var yaw_root : float = 0
@export var yaw : float = 0
@export var pitch : float = 0

@export var yaw_sensitivity : float = 0.1
@export var pitch_sensitivity : float = 0.07

var yaw_acceleration : float = 5
var pitch_acceleration : float = 5

var pitch_max : float = 10
var pitch_min : float = -10

func _ready() -> void:
	Input.warp_mouse(Vector2(get_viewport().size.x/2.,get_viewport().size.y/2.))

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += -event.relative.y * pitch_sensitivity
		
func _physics_process(delta: float) -> void:
	pitch = clamp(pitch, pitch_min,pitch_max)
	rotation_degrees.y = lerp(rotation_degrees.y,yaw_root,0.1)	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y,yaw,yaw_acceleration * delta)
	pitch_node.rotation_degrees.x  = lerp(pitch_node.rotation_degrees.x,pitch,pitch_acceleration *
 delta)
	# yaw_node.rotation_degrees.y = yaw
	# pitch_node.rotation_degrees.x = pitch
