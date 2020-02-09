extends Level

#objects for spawning
onready var itemBagPacked = preload("res://objects/Interactables/itemBag.tscn")
onready var nagaPacked = preload("res://objects/Enemies/Naga.tscn")

var levelSize = 60

func _ready():
	addStage(LevelGenStage.new($guide,"first_area_base", funcref(self, "_stage1_endcheck") ))
	addStage(LevelGenStage.new($guide,"orange_fix", funcref(self, "_fail_endcheck") ))
	addStage(LevelGenStage.new($guide,"first_area_walls", funcref(self, "_3rdsecond_endcheck")))
	addStage(LevelGenStage.new($guide,"first_area_mid", funcref(self, "_25thsecond_endcheck"),$ground ))
	addStage(LevelGenStage.new($guide,"first_area_decor", funcref(self, "_immediate_endcheck"), $play ))

	startGenerating()
	#_genFinishedCallback()


func _stage1_endcheck(feedback):
	if feedback[0].size.y > levelSize or feedback[3] > levelSize/10:
		print(spawnMatchNum("level_mechanicals","simple_spawn1x1", itemBagPacked, 2))
		print(spawnMatchNum("level_mechanicals","simple_spawn3x3", nagaPacked, 3, Vector2(1,1),false,0))
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
func _3rdsecond_endcheck(feedback):
	if feedback[3] > 0.3:
		return true
	else:
		return false
func _5thsecond_endcheck(feedback):
	if feedback[3] > 0.5:
		return true
	else:
		return false


