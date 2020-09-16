extends RigidBody

var PlayerSpeed = 5000
var PlayerRotationSpeed = 500

func _ready():
	linear_damp = 0.99
	angular_damp = 0.99
	gravity_scale = 5



func go_forward(delta: float):
	add_central_force(global_transform.basis.xform(Vector3.FORWARD) * PlayerSpeed * delta)
	
func go_backwards(delta: float):
	add_central_force(global_transform.basis.xform(Vector3.FORWARD) * -PlayerSpeed * delta)

func turn_left(delta : float):
	add_torque(Vector3.UP * PlayerRotationSpeed * delta)

func turn_right(delta : float):
	add_torque(Vector3.UP * -PlayerRotationSpeed * delta)
