extends Area2D

var exitDirection = [false,false,false,false]

func _init(dir = -1):
	setExitDirection(dir)

func _ready():
	pass

func _on_LevelExit_body_entered(body):
	if body.is_in_group("player"):
		# if there's no region, reload current level
		if isEmpty() or ST.currentRegion == null:
			get_tree().reload_current_scene()
			print_debug("empty exit")
		else:
			ST.currentRegion.moveDir(exitDirection)
	

func isEmpty():
	return exitDirection == [false,false,false,false]

func setExitDirection(dir = -1): #default is south
	match dir:
		-1:
			push_error("Warning, no exit direction set")
		0: # north
			exitDirection = [true,false,false,false]
			$faces/up.show()
		1: # east
			exitDirection = [false,true,false,false]
			$faces/right.show()
		2: # south
			exitDirection = [false,false,true,false]
			$faces/down.show()
		3: # west
			exitDirection = [false,false,false,true]
			$faces/left.show()