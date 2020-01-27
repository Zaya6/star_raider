class_name LevelGenStage
extends Node

var stampLibrary = ""
var tileMatcher
var endCheckFR

func _init(patternMap, library, endfunctionRef, stampMap=null):
	# check if a second map is wanted to stamp to, if not set it to stamp on the same map
	if stampMap == null: stampMap = patternMap 
	stampLibrary = library
	tileMatcher = TileMatcher.new(patternMap, stampLibrary, stampMap)
	endCheckFR = endfunctionRef
	
func generate():
	var feedback = tileMatcher.generate()
	return endCheckFR.call_func(feedback)

func setSeed(desiredSeed):
	tileMatcher.setSeed(desiredSeed)

func disableStamp(stampName:String):
	tileMatcher.disableStamp(stampName)

func setStampLimit(stampName:String, nlimit:int):
	tileMatcher.setStampLimit(stampName, nlimit)