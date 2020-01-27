extends Level

#objects for spawning
onready var itemSackObj = preload("res://objects/Interactables/itemSack.tscn")

var levelSize = 20

func _ready():
	autoGenPlayer = false
#	rand.set_seed(1111)
#	levelSeed = 1111
	addStage(LevelGenStage.new($ground,"first_area_base", funcref(self, "_stage1_endcheck")))

	addStage(LevelGenStage.new($ground,"orange_fix", funcref(self, "_fail_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_decor", funcref(self, "_25thsecond_endcheck"), $play ))
	addStage(LevelGenStage.new($ground,"first_area_mid", funcref(self, "_5thsecond_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_randomizer", funcref(self, "_25thsecond_endcheck") ))

	startGenerating()
	

func _stage1_endcheck(feedback):
	if feedback[0].size.y > levelSize or feedback[3] > levelSize/10:
		
		#place item sacks
		#not needed for first level, first level can only go up
#		var itemSackMatcher1 = SingleTileMatcher.new($ground,"level_mechanicals", "itemSack1")
#		var itemSackMatcher2 = SingleTileMatcher.new($ground,"level_mechanicals", "itemSack2")
#		var itemSackMatcher3 = SingleTileMatcher.new($ground,"level_mechanicals", "itemSack3")
		
		return true
	else:
		return false
func _fail_endcheck(feedback):
	if not feedback[2]:
		return true
	else:
		return false
func _1second_endcheck(feedback):
	if feedback[3] > 1:
		return true
	else:
		return false
func _25thsecond_endcheck(feedback):
	if feedback[3] > 0.25:
		return true
	else:
		return false
func _5thsecond_endcheck(feedback):
	if feedback[3] > 0.5:
		return true
	else:
		return false

