extends Area2D

# directions : [up,right,down,left] --clockwise from top
var connection = [false,false,false,false]

func _ready():
	set_position(ST.currentLevel.resetPositionToMap(get_position())+Vector2(0,2))

func _on_LevelExit_body_entered(body):
	if body.is_in_group("player"):
		# if there's no region, reload current level
		if isEmpty() or ST.currentRegion == null:
			get_tree().reload_current_scene()
			print_debug("empty exit")
		else:
			ST.currentRegion.moveDir(connection)
	

# a function to check if there has not been a connection set to another level
func isEmpty():
	return connection == [false,false,false,false]

# connect this exit to another level in the region
# 0=up,1=right,2=south,3=left
func setconnection(dir = -1): #default is south
	match dir:
		-1:
			push_error("Warning, no exit direction set")
		0: # north
			connection = [true,false,false,false]
			$faces/up.show()
		1: # east
			connection = [false,true,false,false]
			$faces/right.show()
		2: # south
			connection = [false,false,true,false]
			$faces/down.show()
		3: # west
			connection = [false,false,false,true]
			$faces/left.show()
