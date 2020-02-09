extends Camera2D

var showGeneration:bool
var map:TileMap

func _ready():
	showGeneration = ST.settings["showGeneration"]
	
	if ST.currentLevel != null:
		map = ST.currentLevel.getMap()
		if showGeneration:
			make_current()

func _process(delta):
	if ST.currentLevel != null and showGeneration:
		if ST.currentLevel.generatingDone:
			ST.currentPlayer.returnFocus()
		else:
			var mapRect:Rect2 = map.get_used_rect()
			position = (mapRect.position + mapRect.size / 2) * 50
