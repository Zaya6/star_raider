extends Level

var levelSize = 60

func _ready():
	addStage(LevelGenStage.new($ground,"first_area_base", funcref(self, "_stage1_endcheck") ))

	addStage(LevelGenStage.new($ground,"orange_fix", funcref(self, "_fail_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_decor", funcref(self, "_25thsecond_endcheck"), $play ))
	addStage(LevelGenStage.new($ground,"first_area_mid", funcref(self, "_5thsecond_endcheck") ))
	addStage(LevelGenStage.new($ground,"first_area_randomizer", funcref(self, "_25thsecond_endcheck") ))

	startGenerating()
	#_genFinishedCallback()


func _stage1_endcheck(feedback):
	if feedback[0].size.y > levelSize or feedback[3] > levelSize/10:
		print_debug("level size: ", feedback[0].size)
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



