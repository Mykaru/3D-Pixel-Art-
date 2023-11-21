extends HSlider
@onready var texel_snapping_node = get_node("../Texel_Snapping")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


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


func change_slider_value(direction):
	# Get the current value of the slider
	var slider_value = value

	# Define the step size for the slider
	var step = .05  # Set the step size to the same as slider's step size

	# Increase or decrease the slider value based on the scroll direction
	slider_value += step * direction

	# Clamp the slider value within its limits
	slider_value = clamp(slider_value, 1, 3)

	# Set the updated value to the slider
	set_value(slider_value)

	# Update the 'Texel Snapping' node using the slider's value
	if texel_snapping_node:
		texel_snapping_node.scale.x = slider_value
		texel_snapping_node.scale.y = slider_value
