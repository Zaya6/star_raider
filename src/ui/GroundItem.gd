extends TextureButton

var groundObject

func setIcon(texture):
	$container/icon.set_texture(texture)

func setGroundObject(object):
	groundObject = object




func _on_GroundItem_pressed():
	print("pressed item: ", groundObject.name)
