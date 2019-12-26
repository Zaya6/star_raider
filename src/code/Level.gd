class_name Level
extends Node2D

var libraryNames = ["first_area_base", "orange_fix", "first_area_mid", "first_area_decor", "first_area_randomizer"]
var baseMatcher:TileMatcher
var orangFixMatcher:TileMatcher
var fillMatcher:TileMatcher
var decorMatcher:TileMatcher
var randomizerMatcher:TileMatcher

var levelSize = 60
var stage:int = 0
var clock:float = 0
var genOn = true
var failGenCheck = 0

func _init():
	randomize()

func _ready():
	baseMatcher = TileMatcher.new($ground,libraryNames[0])
	orangFixMatcher = TileMatcher.new($ground,libraryNames[1])
	fillMatcher = TileMatcher.new($ground,libraryNames[2])
	decorMatcher = TileMatcher.new($ground,libraryNames[3],$decor)
	randomizerMatcher = TileMatcher.new($ground,libraryNames[4])
	
	print("Moving to stage 0")
	
	

func _process(delta):
	clock += delta
	var genCheck
	if genOn and clock > 0.0:
		match stage:
			0:
				genCheck = baseMatcher.generate()
				if genCheck[0].size.y > levelSize or genCheck[3] > levelSize/10: 
					baseMatcher.disableStamp("ground_mu")
					baseMatcher.disableStamp("ground_ml")
					baseMatcher.disableStamp("ground_mr")
					baseMatcher.disableStamp("ground_tur")
					baseMatcher.disableStamp("ground_tul")
					stage = 1
					print("Moving to stage 1")
			1:
				genCheck = baseMatcher.generate()
				if not genCheck[2]:
					failGenCheck += 1
					if failGenCheck > 10 or genCheck[3] > 5: 
						failGenCheck = 0
						stage = 2
						print("Moving to stage 2")
			2:
				genCheck = orangFixMatcher.generate()
				if not genCheck[2]:
					stage = 3
					print("Moving to stage 3")
			3:
				genCheck = decorMatcher.generate()
				if genCheck[3] > 1: 
					stage = 4
					print("Moving to stage 4")
			4:
				genCheck = fillMatcher.generate()
				if genCheck[3] > 1: 
					stage = 5
					print("moving to stage 5")
						
			5:
				genCheck = randomizerMatcher.generate()
				if genCheck[3] > 1: 
					genOn = false
					$"../ui/loading".queue_free()
					print("done generating")
		
		clock = 0

