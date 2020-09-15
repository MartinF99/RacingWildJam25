extends RigidBody

class_name HoverController

var speed : float

var driveForceDefault : float = 170;
var driveForceBoost : float = 19;
var slowingVelFactor : float = 0.99;
var brakingVelFactor : float = 0.95;
var driftMultiplierMin : int = 25;
var driftMultiplierMax : int = 1000;
var jumpForce : int = 2500;


var hoverHeight : float = 2;
var maxGroundDist : float = 5;
var hoverForce : float = 200;
onready var hoverPID : PIDController = $PIDController;


var terminalVelocityDefault = 100;
var terminalVelocityBoost = 150;
var worldGravity = 10;
var fallGravity = 50;


var drag : float;
var isOnGround : bool;

var hit_info;

var rudder = 0;
var thruster = 0;
var is_braking = false;
var is_boosting = false;

func _ready() -> void:
	drag = driveForceDefault / terminalVelocityDefault;
	$GroundRay.set_cast_to(Vector3(0, -maxGroundDist, 0))

func _process(delta: float) -> void:
	rudder = 0
	thruster = 0
	is_braking = false

	if Input.is_action_pressed("forward"):
		thruster = 1
	if Input.is_action_pressed("back"):
		thruster = -1
	if Input.is_action_pressed("left"):
		rudder = 1
	if Input.is_action_pressed("right"):
		rudder = -1
	if Input.is_action_pressed("brake"):
		is_braking = true



func _physics_process(delta: float) -> void:
	speed = linear_velocity.dot(-transform.basis.z);

	check_ground();
	align_to_ground();
	turn();

	add_central_force(calculate_gravity() + hover_force(delta) + calculate_propulsion() + fricition(delta))

func check_ground():
	hit_info = $GroundRay.get_collider()
	isOnGround = $GroundRay.is_colliding()

func align_to_ground():
	pass #TODO

#	private void AlignToGround()
#	{
#		Vector3 groundNormal = isOnGround ? hitInfo.normal.normalized : Vector3.up;
#		Vector3 projection = Vector3.ProjectOnPlane(transform.forward, groundNormal);
#		Quaternion rotation = Quaternion.LookRotation(projection, groundNormal);
#
#		body.MoveRotation(Quaternion.Lerp(body.rotation, rotation, Time.deltaTime * 10f));
#	}

func hover_force(delta):
	if !isOnGround:
		return Vector3.ZERO
	var force_percent : float = hoverPID.seek(hoverHeight, hit_info.global_transform.origin.distance_to(global_transform.origin), delta)
	return $GroundRay.get_collision_normal().normalized() * hoverForce * force_percent


func turn():
	var rotation_torque : float = rudder - angular_velocity.y
	add_torque(Vector3(0, rotation_torque, 0))


#	private void Turn()
#	{
#		Vector3 localAngularVelocity = transform.InverseTransformDirection(body.angularVelocity).normalized * body.angularVelocity.magnitude;
#		float rotationTorque = input.rudder - localAngularVelocity.y;
#		body.AddRelativeTorque(0f, rotationTorque, 0f, ForceMode.VelocityChange);
#	}


func fricition(delta):
	var sideways_speed = linear_velocity.dot(transform.basis.z)

	var current_speed = get_speed_percentage()
	if current_speed >= 0.5:
		current_speed = 1

	var drift_multiplier = lerp(driftMultiplierMax, driftMultiplierMin, current_speed)

	var side_friction = -transform.basis.z * (sideways_speed / delta / drift_multiplier)
	return side_friction


func jump():
	return transform.basis.y * jumpForce


func calculate_propulsion():
	if thruster <= 0:
		linear_velocity *= slowingVelFactor;

	if !isOnGround:
		return Vector3.ZERO;

	if is_braking:
		linear_velocity *= brakingVelFactor;

	var drive_force = driveForceDefault
	var terminalVelocity = terminalVelocityDefault;

	if (is_boosting):
		drive_force = driveForceBoost;
		terminalVelocity = terminalVelocityBoost

	var propulsion = -transform.basis.z * (drive_force * thruster - drag * clamp(speed, 0, terminalVelocity))
	return propulsion


func calculate_gravity():
	if isOnGround:
		return worldGravity * Vector3.DOWN
	else:
		return fallGravity * Vector3.DOWN

func get_speed_percentage():
	return linear_velocity.length() / terminalVelocityDefault;
