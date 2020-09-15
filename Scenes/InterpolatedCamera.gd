extends InterpolatedCamera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var car = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	set_as_toplevel(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
