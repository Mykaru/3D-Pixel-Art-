extends Node3D

# NOTE(david): 768x432 + margin for snap error shift
const width: int = 770
const height: int = 434

const orthographic_size: float = 8
const texel_snap: float = float(height) / orthographic_size

@onready var cam_proxy: Node3D = $Pivot
@onready var cam: Camera3D = $Pivot/Camera3D

@onready var last_rot := cam_proxy.global_rotation
@onready var snap_space := cam_proxy.global_transform


func _process(delta):
	if cam_proxy.global_rotation != last_rot:
		last_rot = cam_proxy.global_rotation
		snap_space = cam_proxy.global_transform
	
	var snap_space_pos := cam_proxy.global_position * snap_space
	var snapped_snap_space_pos: Vector3 = floor(snap_space_pos * texel_snap) / texel_snap
	cam.global_position = snap_space * snapped_snap_space_pos
	cam.global_rotation = cam_proxy.global_rotation

	# NOTE(david): use error to shift the final image on TextureRect/Sprite3D/etc. for extra smooth
	var snap_space_error := snapped_snap_space_pos - snap_space_pos
	var _screen_texel_error := Vector2(snap_space_error.x, -snap_space_error.y) * texel_snap





# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


