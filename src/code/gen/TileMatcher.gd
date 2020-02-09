# x = index % width
# y = index / width
# index = y * width + x

class_name TileMatcher

#internal variables
var baseTilemap:TileMap
var stampTilemap:TileMap
var library:Array
var tilesPlaced:Dictionary
var startTime = -1.0
var rand = RandomNumberGenerator.new()
var genSeed = -1

func _init(ntilemap:TileMap, libraryName:String, nstampTilemap:TileMap=null):
	rand.randomize()
	baseTilemap = ntilemap
	library = TM.stampLibraries[libraryName].duplicate(true)
	
	# Allow to pass a seperate tilemap to stamp onto, so 
	# things can be added to a level but on another layer
	#, possible maybe to use for object spawning by creating a faux tilemap
	if nstampTilemap == null:
		 stampTilemap = baseTilemap
	else:
		stampTilemap = nstampTilemap

func _ready():
	pass

func setSeed(desiredSeed):
	genSeed = desiredSeed
	rand.set_seed(desiredSeed)

#it's faster to loop through the layout once and 
#then loop through each stamp instead of the other way around
func generate():
	#set the start time if one hasn't been set yet
	if startTime == -1.0:
		startTime = OS.get_unix_time()
	#library.shuffle()
	var die: int = rand.randi()%10
	var cover:Rect2 = baseTilemap.get_used_rect()
	var usedCells = baseTilemap.get_used_cells()
	usedCells.push_back(Vector2(0,0))
	var cell:Vector2
	var x:int; var y:int
	var i: int = 0 if die < 5 else usedCells.size() -1
	var loopiter:int = 1 if die < 5 else -1
	# second indentation
	var stamp
	var prob:PoolIntArray
	var patternWidth:int
	var patternHeight:int
	var patternKey:Array
	var patternArea: int
	var patternSize: int
	var j:int = 0
	# third indentation
	var unlock:int
	var checkX:int
	var checkY:int
	var matchFound:bool = false
	
	while i < usedCells.size() and i > -1:
		cell = usedCells[i]
		x = cell.x
		y = cell.y
		
		for stamp in library:
			#check first if it succeeds
			
			# check if stamp is active, then check probability, then check if the stamp has passed its limit
			if not stamp["active"]:
				continue
			prob = stamp["prob"]
			if rand.randi_range(0,prob[1]) > prob[0]:
				continue
			if stamp["limit"] > 0 and stamp["totalSpawns"] >= stamp["limit"]:
				continue
			
			patternWidth = int(stamp["pattern_width"])
			patternHeight = stamp["pattern_height"]
			patternArea = patternWidth * patternHeight*10
			patternKey = stamp["pattern_key"]
			patternSize = patternKey.size()
			j = 0
			while j < patternArea:
				unlock = patternSize
				checkX = x - j % patternWidth 
				checkY = y - j / patternWidth 
				for key in patternKey:
					var tileToCheck = baseTilemap.get_cell( checkX + key[0], checkY + key[1] )
					if key[2] == 0 and tileToCheck >= 0:
						unlock -= 1
					elif tileToCheck == key[2]:
						unlock -= 1 
					else:
						break 
				
				if unlock <= 0:
					pressStamp(stamp["stamp_key"],checkX, checkY)
					stamp["totalSpawns"] += 1
					matchFound = true
					break
					
				j+=1
		i += loopiter
	
	# return relevant data to determine if generation should continue or stop
	# [0] is a rect2 covering the area of generation
	# [1] is a dictionary of tiles placed
	# [2] is true if anything generated during this pass
	# [3] is the time elapsed since generation started in seconds
	return [ stampTilemap.get_used_rect(), tilesPlaced, matchFound, OS.get_unix_time() - startTime ]


func pressStamp(stampKey, x, y):
	for key in stampKey:
		stampTilemap.set_cell(x+key[0], y+key[1], key[2])
		tilesPlaced[str(key[2])] = true

func disableStamp(stampName:String):
	for stamp in library:
		if stamp["name"] == stampName:
			stamp["active"] = false

func setStampLimit(stampName:String, nlimit:int):
	for stamp in library:
		if stamp["name"] == stampName:
			stamp["limit"] = nlimit
