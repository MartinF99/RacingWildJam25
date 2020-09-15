extends VehicleBody
class_name Car

export var engine_force_max : float = 200 
export var brake_force_max : float = 50
export var steering_angle_max : float = 1
export var steering_velocity : float = 5

var steer_target : float = 0
var steering_angle : float = 0 
var acceleration : float = 0
var brake_val : float = 0
var steer_val : float = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _process(delta):
	acceleration = 0
	brake_val = 0
	steer_val = 0
	if Input.is_action_pressed("forward"):
		acceleration = 1
	if Input.is_action_pressed("brake"):
		brake_val = 1
	if Input.is_action_pressed("left"):
		steer_val = 1
	if Input.is_action_pressed("right"):
		steer_val = -1 

func _physics_process(delta):
	engine_force = acceleration * engine_force_max
	brake = brake_val * brake_force_max
	steer_target = steer_val * steering_angle_max
	if steer_target < steering_angle:
		steering_angle -= steering_velocity * delta
		if steer_target > steering_angle:
			steering_angle = steer_target
	elif steer_target > steering_angle:
		steering_angle += steering_velocity * delta
		if steer_target < steering_angle:
			steering_angle = steer_target
	steering = steering_angle
	pass
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
