extends Control

const MARGIN = 8

# 相机
onready var camera = get_viewport().get_camera()
# 父级position3D
onready var parent = get_parent()

onready var label = $Label
onready var arrow = $arrow

# 路标文本
export var text = "" setget set_text

# 是否附着屏幕
export var sticky = true

# 附着距离
export var stickyOffset = 150

func _ready() -> void:
	self.text = text

	if not parent is Spatial:
		push_error("父级节点必须继承 Spatial")

func _process(_delta):
	if not camera.current:
		camera = get_viewport().get_camera()
	var parent_translation = parent.global_transform.origin
	var camera_transform = camera.global_transform
	var camera_translation = camera_transform.origin

	var is_behind = camera_transform.basis.z.dot(parent_translation - camera_translation) > 0

	var distance = camera_translation.distance_to(parent_translation)
	modulate.a = clamp(range_lerp(distance, 0, 2, 0, 1), 0, 1 )

	var unprojected_position = camera.unproject_position(parent_translation)
	var viewport_base_size = (
		get_viewport().get_size_override() if get_viewport().get_size_override() > Vector2(0, 0)
		else get_viewport().size
	)

	if not sticky:
		rect_position = unprojected_position
		visible = not is_behind
		return

	if is_behind:
		if unprojected_position.x < viewport_base_size.x / 2:
			unprojected_position.x = viewport_base_size.x - MARGIN
		else:
			unprojected_position.x = MARGIN

	if is_behind or unprojected_position.x < MARGIN or \
			unprojected_position.x > viewport_base_size.x - MARGIN:
		var look = camera_transform.looking_at(parent_translation, Vector3.UP)
		var diff = angle_diff(look.basis.get_euler().x, camera_transform.basis.get_euler().x)
		unprojected_position.y = viewport_base_size.y * (0.5 + (diff / deg2rad(camera.fov)))

	rect_position = Vector2(
		clamp(unprojected_position.x, MARGIN, viewport_base_size.x - MARGIN),
		clamp(unprojected_position.y, MARGIN, viewport_base_size.y - MARGIN)
	)

	label.visible = true
	rect_rotation = 0
	
	var overflow = 0
	arrow.visible = false

	if rect_position.x <= MARGIN:
		# 左
		overflow = -45
		rect_position.x += stickyOffset
		arrow.visible = true
		arrow.rotation_degrees = 90
		pass
	elif rect_position.x >= viewport_base_size.x - MARGIN:
		# 右
		overflow = 45
		rect_position.x -= stickyOffset
		arrow.visible = true
		arrow.rotation_degrees = 270
		pass

	if rect_position.y <= MARGIN:
		# 上
		rect_position.y += stickyOffset
		arrow.visible = true
		arrow.rotation_degrees = 180 + overflow
		pass
	elif rect_position.y >= viewport_base_size.y - MARGIN:
		# 下
		rect_position.y -= stickyOffset
		arrow.visible = true
		arrow.rotation_degrees = -overflow
		pass

func set_text(p_text):
	text = p_text

	if is_inside_tree():
		label.text = p_text

static func angle_diff(from, to):
	var diff = fmod(to - from, TAU)
	return fmod(2.0 * diff, TAU) - diff
