extends Node2D

var region
var tilematcher
var r

func _ready():
	ST.currentRegion = Region.new([1,1],[3,3], -1, ["res://levels/first_area/FirstArea_story2.tscn"], false, Vector2(0,2))
	ST.currentRegion.addPosCustom(Vector2(0,2),"res://levels/first_area/FirstArea_story1.tscn")
	ST.currentRegion.addPosCustom(Vector2(0,0),"res://levels/first_area/FirstArea_story3.tscn")
	
	ST.currentRegion._drawMap($region)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			ST.currentRegion.loadFirstLevel()
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept"):
			ST.currentRegion.loadFirstLevel()
			#ST.currentRegion.loadFirstLevel() #TODO: if called twice custom level doesn't load
		if Input.is_action_just_pressed("ui_cancel"):
			get_tree().reload_current_scene()
