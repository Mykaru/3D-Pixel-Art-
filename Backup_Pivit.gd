extends Node3D

const SCROLL_SPEED = 4;
const ROTATION_SPEED = 0.1

var UP:bool = false;
var DOWN:bool = false;
var LEFT:bool = false;
var RIGHT:bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

func _input(event):
	#rotation
	if event is InputEventMouseMotion:
		if event.button_mask&(MOUSE_BUTTON_MASK_MIDDLE+MOUSE_BUTTON_MASK_RIGHT):
			self.rotate(Vector3(0, 1, 0), event.relative.x * -0.006)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#scroll (with keyboard)
	if Input.is_key_pressed(KEY_W) or UP:
		self.translate(Vector3(0,0, -SCROLL_SPEED*delta))
		
	if Input.is_key_pressed(KEY_S) or DOWN:
		self.translate(Vector3(0,0, SCROLL_SPEED*delta))
		
	if Input.is_key_pressed(KEY_A) or LEFT:
		self.translate(Vector3(-SCROLL_SPEED*delta, 0, 0))
		
	if Input.is_key_pressed(KEY_D) or RIGHT:
		self.translate(Vector3(SCROLL_SPEED*delta, 0, 0))
		
	#rotation with keyboard
	if Input.is_key_pressed(KEY_Q):
		self.rotate(Vector3(0, 1, 0),2*delta)
	if Input.is_key_pressed(KEY_E):
		self.rotate(Vector3(0, 1, 0),-2*delta)
