extends RigidBody

#consts

#vars
var gravity_ground : float
var gravity_air : float
var is_on_ground : bool
var hover_height : float
var hover_force : float
var gravity : Vector3 # may be removed at a later date 

#onready var
onready var ground_ray : RayCast = $RayCast
onready var pidc : PIDController = $PIDController
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gravity_air = 50
	gravity_ground = 10
	hover_height = 2
	hover_force = 200


func _physics_process(delta) -> void:
	check_ground()
	adjust_gravity()
	add_force(gravity + hover_force(delta), transform.origin)
	
	pass

func hover_force(delta : float) -> Vector3:
	if not is_on_ground:
		return Vector3.ZERO
	var distance_to_ground : float = ground_ray.get_collision_point().distance_to(transform.origin)
	var percentage_of_force : float = pidc.seek(hover_height, distance_to_ground, delta)
	
	return ground_ray.get_collision_normal().normalized() * hover_force * percentage_of_force

#remove if gravity global variable is removed to return a Vector4
func adjust_gravity() -> void: 
	if is_on_ground:
		gravity = gravity_ground * Vector3.DOWN
	else:
		gravity = gravity_air * Vector3.DOWN
	return
	
func check_ground() -> void:
	is_on_ground = ground_ray.is_colliding()
	return 
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
