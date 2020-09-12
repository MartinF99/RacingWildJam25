extends Node

class_name PIDController

export(float) var proportc : float = 0.8
export(float) var integralc : float = 0.0002
export(float) var derivatec: float = 0.2
export(float) var minimum : float = -1
export(float) var maximum : float = 1

var integral  : float = 0
var lastpropo : float = 0


func seek(target : float, current : float, delta : float) -> float:
	var prop : float = target - current
	var derivate = (prop - lastpropo) / delta
	integral += prop * delta
	lastpropo = prop
	var ret_val : float = proportc * prop + integralc * integral + derivatec * derivate 
	ret_val = clamp(ret_val, minimum, maximum)
	return ret_val
