extends Camera2D

var waterPost = null

func _init():
	var zoom = ST.scaleRatio*16
	set_zoom(Vector2(zoom,zoom))


func _ready():
	var throwaway = get_tree().get_nodes_in_group("waterPost")
	if throwaway.size() > 0:
		waterPost = throwaway[0]

func _physics_process(delta):
	if waterPost != null:
		waterPost.material.set_shader_param("cameraPosition", get_camera_position() )