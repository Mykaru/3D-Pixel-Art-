extends HSlider

var is_paused: bool = false
var paused_position: float = 0.0
var anim_name: String = "Sun_Cycle"
@onready var animation_player = get_node("/root/Main/Animations/AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event.is_action_pressed("play_anim"):
		if animation_player.is_playing():
			animation_player.pause()
		else:
			animation_player.play(anim_name)


func _on_value_changed(slider_position):
	var total_length = animation_player.current_animation_length
	var pos = (slider_position - 1) * total_length / 29
	animation_player.seek(pos, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var current_position = animation_player.get_current_animation_position()
	var total_length = animation_player.current_animation_length
	var slider_value = (current_position / total_length) * 29 + 1
	value = slider_value
	

func _on_mouse_exited():
	self.release_focus()
