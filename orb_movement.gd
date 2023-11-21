extends Node3D

var rotation_speed = 30.0
var amplitude = 0.002
var frequency = 4.0
var time_passed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotate_y(deg_to_rad(rotation_speed * delta))
	
	time_passed += delta
	var y_offset = amplitude * sin(frequency * time_passed)
	self.translate(Vector3(0, y_offset, 0))
