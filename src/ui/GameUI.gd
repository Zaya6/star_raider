extends CanvasLayer

#dynamic ui elements
onready var groundItemObj = preload("res://ui/GroundItem.tscn")

var onGround = {}
var logToggle = true

func _init():
	# set self as gameui so things can access it
	ST.gameUI = self
	
	# set scale if not set already
	var size = OS.get_screen_size() if OS.window_fullscreen or OS.window_maximized else OS.window_size
	var basis = size.x if size.x > size.y else size.y
	ST.scaleRatio = 64.0/basis as float

func _ready():
	pass

func addGroundItem(nme, groundObject):
	$onGroundHolder.show()
	var uiElement = groundItemObj.instance()
	uiElement.setIcon(groundObject.getIcon())
	uiElement.setGroundObject(groundObject)
	$onGroundHolder/onGround/items.add_child(uiElement)
	onGround[nme] = uiElement
	
#	print_debug("Adding ground item: ", nme, "\n", onGround)
func removeGroundItem(nme):
	if onGround.has(nme):
		onGround[nme].queue_free()
		onGround.erase(nme)
		
		if onGround.empty():
			$onGroundHolder.hide()
		
#		print_debug("Removing ground item: ", nme, "\n", onGround)

func _on_logToggle_pressed():
	logToggle = not logToggle
	if not logToggle: 
		var hidespace = $screen/top/logbar/log.rect_size.y
		$screen/top/logbar.rect_position.y -= hidespace
	else:
		var hidespace = $screen/top/logbar/log.rect_size.y
		$screen/top/logbar.rect_position.y += hidespace
