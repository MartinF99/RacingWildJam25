extends RigidBody

var PlayerSpeed = 5000
var PlayerRotationSpeed = 500

func _ready():
	linear_damp = 0.99
	angular_damp = 0.99
	gravity_scale = 5

func _physics_process(Delta):
	if Input.is_action_pressed("forward"):
		add_central_force(global_transform.basis.xform(Vector3.FORWARD) * PlayerSpeed * Delta)
	if Input.is_action_pressed("back"):
		add_central_force(global_transform.basis.xform(Vector3.FORWARD) * -PlayerSpeed * Delta)
	if Input.is_action_pressed("left"):
		add_torque(Vector3.UP * PlayerRotationSpeed * Delta)
	if Input.is_action_pressed("right"):
		add_torque(Vector3.UP * -PlayerRotationSpeed * Delta)
