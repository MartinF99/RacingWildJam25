extends RigidBody

#consts

#vars
var gravity_ground : float
var gravity_air : float
#var is_on_ground : bool
var hover_height : float
var hover_force : float
var drive_force : float = 100
var terminal_velocity : float = 150
var slowing_factor : float = 0.99
var braking_factor : float = 0.95


var thruster : float = 0
var rudder : float = 0
var brake : bool = false

var drag : float
var speed : float


var hit_info

#onready var
var ground_rays : Array
onready var ground_ray_origin : RayCast = $GroundRay
onready var pidc : PIDController = $PIDController


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drag = drive_force / terminal_velocity
	gravity_air = 50
	gravity_ground = 10
	hover_height = 2
	hover_force = 200
	ground_rays = get_tree().get_nodes_in_group("stabilizers")


func _process(delta: float) -> void:
	thruster = 0
	rudder = 0
	brake = false
	if Input.is_action_pressed("forward"):
		thruster = 1
	if Input.is_action_pressed("back"):
		thruster = -1
	if Input.is_action_pressed("left"):
		rudder = 1
	if Input.is_action_pressed("right"):
		rudder = -1
	if Input.is_action_pressed("brake"):
		brake = true


func _physics_process(delta) -> void:
	speed = linear_velocity.dot(-global_transform.basis.z)
	#check_ground()
	turn()
	var is_on_ground : bool
	for ground_ray in ground_rays:
		is_on_ground = check_ground(ground_ray)
		ground_ray.force_raycast_update()
		add_force( 1/4 * hover_force(delta, ground_ray, is_on_ground) + 1/4 * adjust_gravity(is_on_ground),ground_ray.transform.origin)
	is_on_ground = check_ground(ground_ray_origin)
	add_force(propulsion(is_on_ground) + adjust_gravity(is_on_ground) + hover_force(delta, ground_ray_origin,is_on_ground), Vector3.ZERO)


func turn():
	var rotation_torque : float = rudder - angular_velocity.y
	add_torque(Vector3(0, rotation_torque, 0))


func hover_force(delta : float, ground_ray : RayCast, is_on_ground : bool) -> Vector3:
	if not is_on_ground:
		return Vector3.ZERO
	var distance_to_ground : float = ground_ray.get_collision_point().distance_to(transform.origin)
	var percentage_of_force : float = pidc.seek(hover_height, distance_to_ground, delta)
	return ground_ray.get_collision_normal().normalized() * hover_force * percentage_of_force


func align_to_ground() -> void:
	var ground_normal : Vector3 = Vector3.UP
	if is_on_ground:
		ground_normal = ground_ray.get_collision_normal().normalized()
	var xform = align_to_y(global_transform, ground_normal)
	var lin_vel = linear_velocity
	var ang_vel = angular_velocity
	global_transform = global_transform.interpolate_with(xform, 0.2)
	linear_velocity = lin_vel
	angular_velocity = ang_vel


func align_to_y(xform : Transform, up : Vector3) -> Transform:
	xform.basis.y = up
	xform.basis.x = -xform.basis.z.cross(up)
	xform.basis = xform.basis.orthonormalized()
	return xform



func adjust_gravity(is_on_ground : bool) -> Vector3:
	if is_on_ground:
		return gravity_ground * Vector3.DOWN
	else:
		return gravity_air * Vector3.DOWN


func check_ground(ground_ray : RayCast) -> bool:
	hit_info = ground_ray.get_collider()
	return ground_ray.is_colliding()


func propulsion(is_on_ground) -> Vector3:
	if thruster >= 0:
		linear_velocity *= slowing_factor

	if not is_on_ground:
		return Vector3.ZERO

	if brake:
		linear_velocity *= braking_factor

	var propulsion : Vector3 = -global_transform.basis.z * (drive_force * thruster - drag)
	return propulsion
