class_name SingleTileMatcher

#selectors
const BOTTOM = 1
const LEFT = 2
const RIGHT = 3

#internal variables
var rand = RandomNumberGenerator.new()
var genSeed = -1
var tilemap:TileMap
var stamp:Dictionary = {}
var patternKey:Array
var startTime = -1.0
var matchList:Array = []
var iterable = false
var lastI = 0
var lastJ = 0

func _init(ntilemap:TileMap, libraryName, stampName, niterable=false):
	tilemap = ntilemap
	iterable = niterable
	for iStamp in TM.stampLibraries[libraryName]:
		if iStamp["name"] == stampName:
			stamp = iStamp
			break
	if stamp.empty(): push_error(stampName + " not found!")
	patternKey = stamp["pattern_key"]

# 0=up,1=right,2=south,3=left
func parse(direction = 0):
	var matches = []
	var usedRect:Rect2 = tilemap.get_used_rect()
	var offsetx:int = stamp["pattern_width"]
	var offsety:int = stamp["pattern_height"]
	var prob = stamp["prob"]
	var limit = stamp["limit"]
	
	#loop modification
	var i = lastI #i is named because it can switch betwen x and y
	var j = lastJ #j is named because it can switch betwen x and y
	var idir = 1
	var jdir = 1
	var iend = usedRect.size.y+offsety*2
	var jend = usedRect.size.x+offsetx*2
	var jreset = 0
	match direction:
		0: # match starting from top, default behavior. case to limt confusion
			pass
		2: # match from bottom
			#start i at y bottom and subtract y value
			i = iend-1
			idir = -1
		3: # match from left side
			iend = usedRect.size.x+offsetx*2
			jend = usedRect.size.y+offsety*2
		1: # match from right side
			iend = usedRect.size.x+offsetx*2
			jend = usedRect.size.y+offsety*2
			i = iend-1
			j = jend-1
			idir = -1
			jdir = -1
			jreset = j

	while i < iend and i > -1:
		j = jreset
		while j < jend and j > -1:
			#check stamp limit, skip loops if at limit
			if limit > 0 and matches.size() >= limit: break
			# if probability check fails, skip to next coord
			if rand.randf_range(0,prob[1]) < prob[0]:
				var finalX
				var finalY
				# depending on the direction, [i,j] might be [x,y], or [y,x]
				# if it's matching from top(default) or bottom i is y and j is x
				if direction == 0 or direction == 2:
					finalX = j + usedRect.position.x-offsetx
					finalY = i + usedRect.position.y-offsety
				# if it's matching from the left or right side then j is y and i is x
				else: 
					finalX = i + usedRect.position.x-offsetx
					finalY = j + usedRect.position.y-offsety
				if checkMatch(finalX,finalY):
					if iterable:
						lastI = i
						lastJ = j+jdir
						matchList.append(Vector2(finalX,finalY))
						return matchList
					else:
						matches.append(Vector2(finalX,finalY))
			j+=jdir
		i+=idir
	
	matchList = matches
	return matches

func getMatches():
	return matchList

#loops through the key tiles in the pattern, if all match it unlocks and matches
func checkMatch(x,y):
	var unlock = patternKey.size()
	for i in patternKey.size():
		var key = patternKey[i]
		var tileToCheck = tilemap.get_cell(x+key[0], y+key[1])
		if key[2] == 0 and tileToCheck >= 0:
			unlock -= 1
			if unlock <= 0:
				return true
		elif tileToCheck  == key[2]:
			unlock -= 1
			if unlock <= 0:
				return true
	return false

func setSeed(desiredSeed):
	genSeed = desiredSeed
	rand.set_seed(desiredSeed)

#func pressStampOnce(stampTilemap, modifier = 1):
#	var selector = matchList.size()/modifier
#	var pos = matchList[

func pressStampv(vector:Vector2, stilemap=null):
	pressStamp(vector.x,vector.y, stilemap)

func pressStamp(x, y, stilemap=null):
	if stilemap == null: stilemap = tilemap
	var stampKey = stamp["stamp_key"]
	for key in stampKey:
		stilemap.set_cell(x+key[0], y+key[1], key[2])
