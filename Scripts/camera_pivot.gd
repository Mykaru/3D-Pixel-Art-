extends Node3D

@export var camera: Camera3D

#Rotation
var rotation_speed = 45.0  # Adjust the rotation speed as needed
var is_rotating = false
var initial_rotation = 0
var final_rotation = 0
var rotation_timer = 0
@export var ROTATION_DURATION = 0.5  # The duration of the rotation in seconds
@export var rotation_ease = 0.3
const SCROLL_SPEED = 4.5;

#Manual translation
var UP:bool = false;
var DOWN:bool = false;
var LEFT:bool = false;
var RIGHT:bool = false;

#Reset Position
var initial_position = position
var final_position = 0
var translation_timer = 0
@export var TRANSLATION_DURATION = 1
@export var translation_ease = 0.5
var is_scrolling = false



func _input(event):
	if event.is_action_pressed("rotate_left"):
		rotate_object(deg_to_rad(rotation_speed))
	if event.is_action_pressed("rotate_right"):
		rotate_object(deg_to_rad(-rotation_speed))
	if event.is_action_pressed("Reset Camera"):
		reset_position()

func rotate_object(target_rotation):
	if !is_rotating:
		is_rotating = true
		initial_rotation = rotation_degrees.y
		final_rotation = initial_rotation + rad_to_deg(target_rotation)
		rotation_timer = 0

func reset_position():
	if !is_scrolling:
		is_scrolling = true
		initial_position = position
		final_position = Vector3(0, 0, 0)
		translation_timer = 0

func _process(delta):
	if is_rotating:
		rotation_timer += delta
		var t = min(rotation_timer / ROTATION_DURATION, 1.0)
		t = ease(t, rotation_ease)

		rotation_degrees.y = initial_rotation + (final_rotation - initial_rotation) * t
		if t >= 1.0:
			is_rotating = false
	
	if is_scrolling:
		translation_timer += delta
		var t2 = min(translation_timer / TRANSLATION_DURATION, 1.0)
		t2 = ease(t2, translation_ease)
		
		position = initial_position + (final_position - initial_position) * t2
		if t2 >= 1.0:
			is_scrolling = false
	
	
	var direction = Vector3(
		int(Input.is_key_pressed(KEY_D) or RIGHT) - int(Input.is_key_pressed(KEY_A) or LEFT),
		0,
		int(Input.is_key_pressed(KEY_S) or DOWN) - int(Input.is_key_pressed(KEY_W) or UP)
	)
	if direction.length_squared() > 0:
		direction = direction.normalized()
		
	self.translate(direction * SCROLL_SPEED * delta)
	
	
	

