extends CanvasLayer

#ground viewer variables
onready var groundItemObj = preload("res://ui/GroundItem.tscn")
var onGround = {}

func _init():
	# TODO: kill self and only set as ST.gameUI if platform is mobile. 	
	# set self as gameui so things can access it
	print_debug(ST.settings["logbarOpen"])
	ST.gameUI = self

func _ready():
	# set logbar position to last position
	openCloseLogbar()
	openCloseGroundViewer()
	pass

#### Ground Viewer functions ####
func addGroundItem(nme, groundObject):
	$screen/middle/c/c/groundViewer.show()
	var item = groundItemObj.instance()
	item.setIcon(groundObject.getIcon())
	item.setGroundObject(groundObject)
	$screen/middle/c/c/groundViewer/groundView/list.add_child(item)
	onGround[nme] = item
	

func removeGroundItem(nme):
	if onGround.has(nme):
		onGround[nme].queue_free()
		onGround.erase(nme)
		
		if onGround.empty():
			$screen/middle/c/c/groundViewer.hide()
			pass

func openCloseGroundViewer():
	if not ST.settings["groundViewerOpen"]: 
		if $screen/middle/c/c/groundViewer/groundView.visible:
			$screen/middle/c/c/groundViewer/groundView.hide()
			$screen/middle/c/c/groundViewer/GroundToggle.text = "Ground  ▲"
	else:
		$screen/middle/c/c/groundViewer/groundView.show()
		$screen/middle/c/c/groundViewer/GroundToggle.text = "Ground  ▼"

func _on_GroundToggle_pressed():
	ST.settings["groundViewerOpen"] = not ST.settings["groundViewerOpen"]
	openCloseGroundViewer()
	
#### Log functions ####
func openCloseLogbar():
	if not ST.settings["logbarOpen"]: 
		var hidespace = $screen/top/logbar/log.rect_size.y
		if not $screen/top/logbar/logToggle/toggleIcon/downIcon.visible:
			$screen/top/logbar/log.hide()
			$screen/top/logbar/spacer.show()
			$screen/top/logbar/logToggle/toggleIcon/downIcon.show()
	else:
		$screen/top/logbar/logToggle/toggleIcon/downIcon.hide()
		$screen/top/logbar/log.show()
		$screen/top/logbar/spacer.hide()

# logbar toggle signal
func _on_logToggle_pressed():
	ST.settings["logbarOpen"] = not ST.settings["logbarOpen"]
	openCloseLogbar()
