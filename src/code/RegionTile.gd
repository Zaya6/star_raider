class_name RegionTile
extends Node

var assignedLevel = null
var levelSeed = 0
var defaultLevels = []

var connections = [false,false,false,false]
var gen

func _init(generator, levels, allowEmpty):
	gen = generator
	defaultLevels = levels
	levelSeed = gen.randi()
	generateConnections(allowEmpty)

func randBool():
	if gen.randi() % 10 < 5: return false; else: return true

func isEmpty():
	if connections == [false,false,false,false]:
		return true
	else:
		return false

func generateConnections(allowEmpty=true, guide=[true,true,true,true]):
	if guide[0]:
		connections[0] = randBool()
	if guide[1]:
		connections[1] = randBool()
	if guide[2]:
		connections[2] = randBool()
	if guide[3]:
		connections[3] = randBool()
	
	while not allowEmpty and isEmpty():
		if guide[0]:
			connections[0] = randBool()
		if guide[1]:
			connections[1] = randBool()
		if guide[2]:
			connections[2] = randBool()
		if guide[3]:
			connections[3] = randBool()

func spawnLevel(levelCustom=null):
	if assignedLevel == null:
		if levelCustom == null:
			# if no level has been assigned, and no custom level is provided
			# pick a random one from the default levels list
			assignedLevel = defaultLevels[gen.randi() % defaultLevels.size()]
		else:
			assignedLevel = levelCustom
	else:
		assignedLevel = defaultLevels[gen.randi() % defaultLevels.size()]
	
	var level = load(assignedLevel)
	ST.get_tree().change_scene_to(level)
	ST.currentLevel.connections = connections

func isAssignedLevel():
	return not assignedLevel == null

func connectToPosition(pos1,pos2):
	var pos = [ pos2[0]-pos1[0], pos2[1]-pos1[1] ]
	#print(pos)
	match pos:
		[0,-1]:
			connections[0] = true
		[1,0]:
			connections[1] = true
		[0,1]:
			connections[2] = true
		[-1,0]:
			connections[3] = true
	

func getConnectingTiles(pos):		
	var connectedTiles = []
	#check top
	if connections[0]:
		connectedTiles.append([pos[0],pos[1]-1])
	#check right
	if connections[1]:
		connectedTiles.append([pos[0]+1,pos[1]])
	#check below
	if connections[2]:
		connectedTiles.append([pos[0],pos[1]+1])
	#check left
	if connections[3]:
		connectedTiles.append([pos[0]-1,pos[1]])
	
	return connectedTiles