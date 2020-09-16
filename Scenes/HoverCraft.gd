extends RigidBody

var PlayerSpeed = 5000
var PlayerRotationSpeed = 500

func _ready():
	linear_damp = 0.99
	angular_damp = 0.99
	gravity_scale = 5

func _physics_process(delta):
	if Input.is_action_pressed("forward"):
		go_forward(delta)
	if Input.is_action_pressed("back"):
		go_backwards(delta)
	if Input.is_action_pressed("left"):
		turn_left(delta)
	if Input.is_action_pressed("right"):
		turn_right(delta)

func go_forward(delta: float):
	add_central_force(global_transform.basis.xform(Vector3.FORWARD) * PlayerSpeed * delta)

func go_backwards(delta: float):
	add_central_force(global_transform.basis.xform(Vector3.FORWARD) * -PlayerSpeed * delta)

func turn_left(delta : float):
	add_torque(Vector3.UP * PlayerRotationSpeed * delta)

func turn_right(delta : float):
	add_torque(Vector3.UP * -PlayerRotationSpeed * delta)
