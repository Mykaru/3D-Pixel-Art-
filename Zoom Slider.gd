extends HSlider
@onready var texel_snapping_node = get_node("../Texel_Snapping")

#zoom reset 
var translation_timer = 0
@export var TRANSLATION_DURATION = 1
@export var translation_ease = 0.5
var is_scrolling = false
var initial_zoom = 0
var final_zoom = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	value = 1.4


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_scrolling:
		translation_timer += delta
		var t2 = min(translation_timer / TRANSLATION_DURATION, 1.0)
		t2 = ease(t2, translation_ease)
		
		value = initial_zoom + (final_zoom - initial_zoom) * t2
		if t2 >= 1.0:
			is_scrolling = false
	


func _on_value_changed(slider_position):
	texel_snapping_node.scale.x = slider_position
	texel_snapping_node.scale.y = slider_position

func _input(event):
	if event is InputEventMouse:
		# Check for mouse wheel movement
		if event.is_action("mousewheel_up"):
			change_slider_value(1)  # Increase slider value
		elif event.is_action("mousewheel_down"):
			change_slider_value(-1)  # Decrease slider value
			
	if event.is_action("reset_zoom"):
		reset_zoom()
		
func reset_zoom():
	if !is_scrolling:
		is_scrolling = true
		initial_zoom = value
		final_zoom = 1.5
		translation_timer = 0


func change_slider_value(direction):
	# Get the current value of the slider
	var slider_value = value

	# Define the step size for the slider
	var step = .05  # Set the step size to the same as slider's step size

	# Increase or decrease the slider value based on the scroll direction
	slider_value += step * direction

	# Clamp the slider value within its limits
	slider_value = clamp(slider_value, 1, 5)

	# Set the updated value to the slider
	set_value(slider_value)

	# Update the 'Texel Snapping' node using the slider's value
	if texel_snapping_node:
		texel_snapping_node.scale.x = slider_value
		texel_snapping_node.scale.y = slider_value
