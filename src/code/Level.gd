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
var rand = RandomNumberGenerator.new()
var _entityList = []
var connections = [false,false,false,false]
var playerOrigin = [false,false,false,false]

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
	_onStart()
	rand.set_seed(levelSeed)
	print_debug("Level seed: ", levelSeed)

func _process(delta):
	# only run if there are stages to run
	if genOn:
		if stages.size() > 0:
			# generate first stage
			if stages[0].generate():
				#always auto generate exits after first stage
				if autoGenExits:
					generateExits()
					autoGenExits = false
				
				#if generation returns true, then stage is finished and is removed
				stages.pop_front()
		else:
			if _endStage():
				stopGenerating()

#### helper functions ####

func addEntity(entity)->int:
	_entityList.append(entity)
	return _entityList.size()-1 #return index

func removeEntity(index)->void:
	_entityList.remove(index)

func executeTurns()->void:
	for entity in _entityList:
		entity.executeTurn()

func setConnections(nconnections)->void:
	connections = nconnections

func addStage(stage : LevelGenStage):
	stage.setSeed(levelSeed)
	stages.append(stage)

func startGenerating():
	genOn = true

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
	return $ground as TileMap

func resetPositionToMap(pos:Vector2)->Vector2:
	return $ground.map_to_world($ground.world_to_map(pos)) + Vector2(32,32)

#### Generating functions ####

func generateExits():	
	print_debug("Generating exits! con:",connections, " origin:", playerOrigin)
	
	if connections[0]: # if level connects north
		var pos = spawnMatchObject($ground, "level_mechanicals","top_exit", levelExitPack, Vector2(0,6), 3, 0, true, 0, true)
		if autoGenPlayer and playerOrigin[0]:
			var player = playerPack.instance()
			player.set_position($ground.map_to_world(pos[0]+Vector2(0,7))+Vector2(32,32))
			$play.add_child(player)
			
	if connections[1]: #east
		var pos = spawnMatchObject($ground, "level_mechanicals","right_exit", levelExitPack, Vector2(3,0), 3, 3, true, 1, true)
		if autoGenPlayer and playerOrigin[1]:
			var player = playerPack.instance()
			player.set_position($ground.map_to_world(pos[0]+Vector2(2,0))+Vector2(32,32))
			$play.add_child(player)
		
	if connections[2]: #south
		var pos = spawnMatchObject($ground, "level_mechanicals","bottom_exit", levelExitPack, Vector2(0,3), 3, 1, true, 2, true)
		if autoGenPlayer and playerOrigin[2]:
			var player = playerPack.instance()
			player.set_position($ground.map_to_world(pos[0]+Vector2(0,2))+Vector2(32,32))
			$play.add_child(player)
			
	if connections[3]: #west
		var pos = spawnMatchObject($ground, "level_mechanicals","left_exit", levelExitPack, Vector2(6,0), 3, 2, true, 3, true)
		if autoGenPlayer and playerOrigin[3]:
			var player = playerPack.instance()
			player.set_position($ground.map_to_world(pos[0]+Vector2(7,0))+Vector2(32,32))
			$play.add_child(player)
	
	#if there is no player origin
	if autoGenPlayer and playerOrigin == [false,false,false,false]:
		spawnMatchObject($ground, "level_mechanicals","simple_player_spawn", playerPack, Vector2(1,1), 1, 3, false, -1, true)
	
	#run callback
	_onExitsGenerated()

# 1 function call to match and spawn an object in this level
func spawnMatchObject(tilemap, libraryName, stampName, packedObject, offset=Vector2(0,0), matchModifier=1, direction=0, pressStamp=false, exitDirection=-1, once=false):
	var matches = []
	var spawnedLocations = []
	
	var matcher = SingleTileMatcher.new(tilemap, libraryName, stampName)
	matcher.setSeed(levelSeed)
	matches = matcher.parse(direction)
	
	#if nothing was matched return an empty array
	if matches.size() == 0: 
		return []
	
	var spawnLimit = matches.size()/matchModifier
	if spawnLimit == 0: spawnLimit = 1

	for i in matches.size():
		i = i if not once else rand.randi() % spawnLimit
		if i < spawnLimit:
			var m = matches[i]
			spawnedLocations.append(m)

			if pressStamp:
				matcher.pressStamp(m.x,m.y)
			var obj
			if exitDirection > -1:
				obj = packedObject.instance()
				obj.setExitDirection(exitDirection)
			else:
				obj = packedObject.instance()
			obj.set_position($ground.map_to_world(m+offset))
			$play.add_child(obj)
			if once:
				return [m]
		else:
			return spawnedLocations
		
	return spawnedLocations

func stopGenerating():
	genOn = false
	_onFinished()

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