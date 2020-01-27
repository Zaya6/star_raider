extends HSplitContainer

var groundObject

func setIcon(texture):
	$TextureButton.texture_normal = texture

func setGroundObject(object):
	groundObject = object

func _on_TextureButton_pressed():
	groundObject.activate()
