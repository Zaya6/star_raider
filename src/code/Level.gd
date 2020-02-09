class_name Level
extends Node2D

#objects for spawning
var levelExitPack = preload("res://objects/Mechanicals/LevelExit.tscn")
var playerPack = preload("res://objects/Player.tscn")

#variables to modify behavior
var autoGenPlayer = true
var autoGenExits = true

#internal use variables
var levelSeed = -1
var stages = Array()
var genOn = false
var generatingDone = false
var rand = RandomNumberGenerator.new()
var _entityList = []
var connections = [false,false,false,false] #directions this level connects to others
var exits = [null,null,null,null] #edit object for changing outward levels
var playerOrigin = [false,false,false,false] #directtion player entered from
var iterations = 0
var startTime = 0.0
var endTime = 0.0

func _init():
	# set globally as the currently running game level
	ST.currentLevel = self
	
	if ST.currentRegion == null and levelSeed == -1:
		rand.randomize()
		levelSeed = rand.randi()
	else:
		levelSeed = ST.currentRegion.getCurrentSeed()
		connections = ST.currentRegion.getCurrentConnections()
		playerOrigin = getPlayerOrigin()
	
	# call _onstart before generator is seeded, in case
	# a custom seed is desired
	
	rand.set_seed(levelSeed)
	print_debug("Level seed: ", levelSeed)
	

func _process(delta):
	# only run if there are stages to run
	if genOn:
		if iterations == 0:
			_onStart()
			startTime = OS.get_unix_time()
		if stages.size() > 0:
			# generate first stage
			if stages[0].generate():
				#always auto generate exits after first stage
				if autoGenExits:
					generateExits()
					autoGenExits = false
				
				#if generation returns true, then stage is finished and is removed
				stages.pop_front()
			iterations += 1
		else:
			if _endStage():
				stopGenerating()

#### callbacks to change behavior ####

# special customizable end stage
# called before generation is turned off
# may be used to add additional
func _endStage():
	return true

func _onFinished():
	pass

func _onStart():
	pass

func _onExitsGenerated():
	pass	

#built in endchecks
func _immediate_endcheck(feedback):
	return true

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

#### helper functions ####

func addEntity(entity)->int:
	_entityList.append(entity)
	return _entityList.size()-1 #return index

func removeEntity(index)->void:
	_entityList.remove(index)

func executeTurns()->void:
	for entity in _entityList:
		if is_instance_valid(entity):
			entity.executeTurn()

func setConnections(nconnections)->void:
	connections = nconnections

func addStage(stage : LevelGenStage):
	stage.setSeed(levelSeed)
	stages.append(stage)

func startGenerating():
	genOn = true

func stopGenerating():
	genOn = false
	$guide.hide()
	endTime = OS.get_unix_time()
	generatingDone = true
	print_debug("Level generation load=",endTime-startTime)
	_onFinished()

func getPlayerOrigin():
	match ST.currentRegion.lastMoveDirection:
		[true,false,false,false]:
			return [false,false,true,false]
		[false,true,false,false]:
			return [false,false,false,true]
		[false,false,true,false]:
			return [true,false,false,false]
		[false,false,false,true]:
			return [false,true,false,false]
	
	return [false,false,false,false]

func getMap()->TileMap:
	#guide is the base tilemap to generate from, it shows where ground is
	return $guide as TileMap

func resetPositionToMap(pos:Vector2)->Vector2:
	return $guide.map_to_world($guide.world_to_map(pos)) + Vector2(32,32)

#### Generating functions ####

func generateExits():	 
	print_debug("Generating exits! con:",connections, " origin:", playerOrigin)
	
	if connections[0]: # if level connects north
		var pos = placeExit(0,Vector2(0,6))
		if autoGenPlayer and playerOrigin[0]:
			var player = playerPack.instance()
			player.set_position($guide.map_to_world(pos+Vector2(0,7))+Vector2(32,32))
			$play.add_child(player)
			
	if connections[1]: #east
		var pos = placeExit(1,Vector2(3,0))
		if autoGenPlayer and playerOrigin[1]:
			var player = playerPack.instance()
			player.set_position($guide.map_to_world(pos+Vector2(2,0))+Vector2(32,32))
			$play.add_child(player)
		
	if connections[2]: #south
		var pos = placeExit(2,Vector2(0,3))
		if autoGenPlayer and playerOrigin[2]:
			var player = playerPack.instance()
			player.set_position($guide.map_to_world(pos+Vector2(0,2))+Vector2(32,32))
			$play.add_child(player)
			
	if connections[3]: #west
		var pos = placeExit(3,Vector2(6,0))
		if autoGenPlayer and playerOrigin[3]:
			var player = playerPack.instance()
			player.set_position($guide.map_to_world(pos+Vector2(7,0))+Vector2(32,32))
			$play.add_child(player)
	
	
	#if there is no player origin
	if autoGenPlayer and playerOrigin == [false,false,false,false]:
		if  rand.randf_range(0,1) > 0.5:
			spawnMatchNum("level_mechanicals", "simple_spawn3x3", playerPack, 1, Vector2(1,1), false, 1)
		else:
			spawnMatchNum("level_mechanicals", "simple_spawn3x3", playerPack, 1, Vector2(1,1), false, 3)
	
	#run callback
	_onExitsGenerated()

func matchStamp(matchTo,libraryName, stampName, dir=0):
	var matcher = SingleTileMatcher.new(matchTo, libraryName, stampName)
	matcher.setSeed(levelSeed)
	matcher.parse(dir)
	return matcher

func placeExit(direction, offset=Vector2(0,0)):
	var stampName = "top_exit"
	match direction:
		1:
			stampName = "right_exit"
		2:
			stampName = "bottom_exit"
		3:
			stampName = "left_exit"
	
	var matcher:SingleTileMatcher = matchStamp($guide,"level_mechanicals", stampName, direction)
	var matches:Array = matcher.getMatches()
	var spawnLocation:Vector2 = matches[0] if matches.size() == 1 else matches[rand.randi_range(0, matches.size()/3)]
	
	matcher.pressStampv(spawnLocation)
	var exit = levelExitPack.instance()
	exit.set_position($guide.map_to_world(spawnLocation+offset))
	exit.setconnection(direction)
	$play.add_child(exit)
	exits[direction] = exit
	return spawnLocation
	

func spawnMatch(libraryName, stampName, packedObject:PackedScene, offset=Vector2(0,0), pressStamp=false,dir=0):
	var matcher:SingleTileMatcher = matchStamp($guide,libraryName,stampName, dir)
	for pos in matcher.getMatches():
		var obj = packedObject.instance()
		obj.set_position($guide.map_to_world(pos+offset))
		if pressStamp: matcher.pressStampv(pos)
		$play.add_child(obj)
	return matcher.getMatches()

func spawnMatchNum(libraryName:String, stampName:String, packedObject:PackedScene, num:int=0, offset=Vector2(0,0), pressStamp=false,dir:int=-1):
	dir = dir if dir > 0 and dir < 4 else rand.randi_range(0,3)
	var matcher:SingleTileMatcher = matchStamp($guide,libraryName,stampName, dir)
	var matches:Array = matcher.getMatches()
	
	#if no number limit is provided or the number of matches is less than or equal
	#to the number of matches then just use them directly
	if num == 0 or matches.size() <= num:
		for pos in matches:
			var obj = packedObject.instance()
			obj.set_position($guide.map_to_world(pos+offset))
			if pressStamp: matcher.pressStampv(pos)
			$play.add_child(obj)
		return matches
	else: # if user provides a number limit, pick matches to spawn randomly
		var ranIndexes = []
		while ranIndexes.size() < num:
			var pick = rand.randi_range(0,matches.size()-1)
			if ranIndexes.find(pick) == -1:
				ranIndexes.append(pick)
		var spawnLocations = []
		for i in ranIndexes:
			var pos = matches[i]
			var obj = packedObject.instance()
			obj.set_position($guide.map_to_world(pos+offset))
			if pressStamp: matcher.pressStampv(pos)
			$play.add_child(obj)
			spawnLocations.append(pos)
		return spawnLocations
			




