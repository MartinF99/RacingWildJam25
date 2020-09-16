extends Spatial

export(float) var hover_force = 200.0
export(float) var stiffness = 0.02
export(float) var damping = 0.002
export(float) var hover_height = 4.0


var force_to_add = Vector3()
var offset = 0.0
var prev_offset = 0.0
var damp_speed = 0.0

var parent

onready var ray = $Ray


func _ready():
	parent = get_parent()
	ray.cast_to.y = -hover_height
	ray.add_exception(parent)


func _physics_process(delta):
	if(ray.is_colliding()):
		prev_offset = offset
		offset = (ray.cast_to - global_transform.xform_inv(ray.get_collision_point())).length()
		damp_speed = (offset - prev_offset) / delta
		var spring_force = parent.gravity_scale * parent.weight * stiffness * offset
		var damping_force = damping * damp_speed
		force_to_add = Vector3.UP * clamp(spring_force + damping_force, 0, 50)
	else:
		force_to_add = Vector3.ZERO

	parent.add_force(parent.global_transform.basis.xform(force_to_add * delta * hover_force), global_transform.origin - parent.global_transform.origin)
