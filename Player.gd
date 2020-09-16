extends Node

var car_scene = load("res://Scenes/Car.tscn")
var hover_craft_scene = load("res://Scenes/HoverCraft.tscn")
var current_vehicle
var current_vehicle_name

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	current_vehicle = car_scene.instance()
	current_vehicle_name = "car"
	add_child(current_vehicle)


func _process(delta):
	if Input.is_action_pressed("switch"):
		switch()


func switch():
	var glob_trans = current_vehicle.global_transform
	current_vehicle.queue_free()
	if current_vehicle_name == "car":
		current_vehicle = hover_craft_scene.instance()
		current_vehicle_name = "hoverboard"
	elif current_vehicle_name == "hoverboard":
		current_vehicle = car_scene.instance()
		current_vehicle_name = "car"
	current_vehicle.global_transform = glob_trans
	add_child(current_vehicle)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
