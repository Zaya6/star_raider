extends Level

var libraryNames = ["first_area_base", "orange_fix", "first_area_mid", "first_area_decor", "first_area_randomizer"]
var levelSize = 60


func _init():
	randomize()

func _ready():
	addStage(LevelGenStage.new($ground,"first_area_base", funcref(self, "_stage1_endcheck") ))
	
	#second stage based on first library with some stamps disabled
	var secondBase = LevelGenStage.new($ground,"first_area_base", funcref(self, "_stage2_endcheck") )
	secondBase.disableStamp("ground_mu")
	secondBase.disableStamp("ground_ml")
	secondBase.disableStamp("ground_mr")
	secondBase.disableStamp("ground_tur")
	secondBase.disableStamp("ground_tul")
	addStage(secondBase)

	addStage(LevelGenStage.new($ground,"orange_fix", funcref(self, "_fail_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_decor", funcref(self, "_1second_endcheck"), $decor ))
	addStage(LevelGenStage.new($ground,"first_area_mid", funcref(self, "_1second_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_randomizer", funcref(self, "_1second_endcheck") ))
	
	starGenerating()


func _stage1_endcheck(feedback):
	if feedback[0].size.y > levelSize or feedback[3] > levelSize/10:
		return true
	else:
		return false
func _stage2_endcheck(feedback):
	if feedback[3] > 5:
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