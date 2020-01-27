extends Node2D

var region
var tilematcher
var r

func _ready():
	ST.currentRegion = Region.new([1,1],[3,3],-1, ["res://levels/first_area/FirstArea_story2.tscn"], false, Vector2(0,2))
	ST.currentRegion.addPosCustom(Vector2(0,2),"res://levels/first_area/FirstArea_story1.tscn")
	ST.currentRegion.loadFirstLevel()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().reload_current_scene()