class_name Region

# TODO: Find simpler way to force no empty tiles on region

var rand = RandomNumberGenerator.new()
var allowEmpty = true
var levels = []
var width = 0
var height = 0

# gameplay variables
var depth = 0
var depthCustoms = {}
var posCustoms = {}
var pos = Vector2(0,0)
var lastMoveDirection = [false,false,false,false]

func _init(widthR=[3,6], heightR=[3,6], nseed = -1, defaultLevelPaths=[], nallowEmpty=true, npos=null):
	allowEmpty = nallowEmpty
	# set seed for region
	# if no seed is given, then randomize everything
	if nseed == -1: 
		randomize()
		rand.set_seed(randi())
	else:
		rand.set_seed(nseed)
		
	width = rand.randi_range(widthR[0],widthR[1])
	height = rand.randi_range(heightR[0],heightR[1])
	
	# allow specification of starting position in region
	if npos == null:
		pos = Vector2(rand.randi() % width, rand.randi() % height)
	else:
		pos = npos
	
	print_debug("generated region: ", width,"/", height, " ", pos)
	
	#fill in random tiles
	for y in height:
		levels.append([])
		for x in width:
			levels[y].append( RegionTile.new(rand, defaultLevelPaths, nallowEmpty) )
	
	_fixConnections()
	_removeIslands()
	
	#this would be a good place to customize the level or change position before it loads
	_onGenFinished()

func _ready():
	pass

#### gamplay functions ####

# run custom code after generation, usually to modify the generated level
func _onGenFinished():
	pass

# by using _ongenfinished, an exist can be added to the region. (At the region edge)
# this runs when the region has been exited
func _onOutofRegion(x,y):
	#default to an error, because usually this is means a bug
	push_error(str(x) + ":" + str(y) + " is out of region")

# allow custom function to check movement and cause some other behavior to happen
# other than default behavior. Returning true allows move to continue, false cancels move
func _onMove(x,y):
	return true

#meant to be used by level exits. Returns the next level
func moveDir(direction):
	lastMoveDirection = direction
	match direction:
		[true,false,false,false]:
			move(0,-1)
		[false,true,false,false]:
			move(1,0)
		[false,false,true,false]:
			move(0,1)
		[false,false,false,true]:
			move(-1,0)

func move(x,y):
	# check if movement is within region
	if pos.x + x > -1 and pos.x + x < width and pos.y + y > -1 and pos.y + y < height:
		# run onmove, to run custom code and to see if another level is needed
		if _onMove(x,y):
			pos.x += x
			pos.y += y
			# check if level has been visited, if not increase depth
			if not levels[y][x].isAssignedLevel():
				depth += 1
			print_debug("move to: ", pos)
			loadLevel(pos,depth)
			
	else:
		print("out!", pos + Vector2(x,y))
		_onOutofRegion(x,y)

func loadFirstLevel():
	return loadLevel(pos,depth)

func getCurrentConnections():
	return levels[pos.y][pos.x].connections

func getCurrentSeed():
	return levels[pos.y][pos.x].levelSeed

# Put in specific levels to be used when the player reaches certain depths
# It adds the level specified as a resource path at the depth desired. These 
# are stored in a dictionary (depthCustoms) which is checked when a player moves
# between levels
func addDepthCustom(depth:int, levelPath:String):
	depthCustoms[depth]  = levelPath

# pos customs is similar to the above but for the player's position in the region
func addPosCustom(pos:Vector2, levelPath:String):
	posCustoms[pos] = levelPath

func loadLevel(pos:Vector2, depth:int):
	# don't even try poscustoms or depthcustoms if the level has been visited.
	# (if a tile has an assigned level, that means it's been visited before.)
	# should be fine regardless, just in case
	if not levels[pos.y][pos.x].isAssignedLevel():
		if posCustoms.has(pos):
			# load the custom pos level and assign it to the tile
			return levels[pos.y][pos.x].spawnLevel(posCustoms[pos])
		elif depthCustoms.has(depth):
			# load the custom depth level and assign it to the tile
			return levels[pos.y][pos.x].spawnLevel(depthCustoms[depth])
		else:
			return levels[pos.y][pos.x].spawnLevel()
	else:
		return levels[pos.y][pos.x].spawnLevel()

#### internal functions ####

func _fixConnections():
	for y in height:
		for x in width:
			var tile = levels[y][x]
			#manage a connection guide, so regenerated tiles don't connect out of region
			var allowEmptyGuide = [true,true,true,true]
			
			#check above tile
			if y - 1 < 0:
				tile.connections[0] = false
				allowEmptyGuide[0] = false
			else:
				tile.connections[0] = levels[y-1][x].connections[2]
		
			#check right of tile
			if x + 1 >= width:
				tile.connections[1] = false
				allowEmptyGuide[1] = false
			else:
				tile.connections[1] = levels[y][x+1].connections[3]
		
			#check below tile
			if y + 1 >= height:
				tile.connections[2] = false
				allowEmptyGuide[2] = false
			else:
				tile.connections[2] = levels[y+1][x].connections[0]
		
			#check left of tile
			if x - 1 < 0:
				tile.connections[3] = false
				allowEmptyGuide[3] = false
			else:
				tile.connections[3] = levels[y][x-1].connections[1]
			
			# add connections to the sorrounding tile if tile is empty
			# and allowEmpty is false
			if not allowEmpty and tile.isEmpty():
				#reset tile connections
				tile.generateConnections(allowEmpty,allowEmptyGuide)
				
				#check above tile
				if y - 1 < 0:
					tile.connections[0] = false
				else:
					levels[y-1][x].connections[2] = tile.connections[0]
			
				#check right of tile
				if x + 1 >= width:
					tile.connections[1] = false
				else:
					levels[y][x+1].connections[3] = tile.connections[1]
			
				#check below tile
				if y + 1 >= height:
					tile.connections[2] = false
				else:
					levels[y+1][x].connections[0] = tile.connections[2]
			
				#check left of tile
				if x - 1 < 0:
					tile.connections[3] = false
				else:
					levels[y][x-1].connections[1] = tile.connections[3]

func _removeIslands():
	var islands = []
	var checkedTiles = []
	for y in height:
		for x in width:
			if not levels[y][x].isEmpty() and checkedTiles.find([x,y]) == -1: 
				var island = _mapIsland(x,y)
				islands.append(island)
				checkedTiles = checkedTiles + island
	
	var endcase = 1000
	#print(islands.size())
	while islands.size() > 1:
		var connectionFound = false
		for pos1 in islands[0]:
			for pos2 in islands[1]:
				if abs(pos2[0] - pos1[0]) == 1 and abs(pos2[1] - pos1[1]) == 0:
					connectionFound = true
				elif abs(pos2[0] - pos1[0]) == 0 and abs(pos2[1] - pos1[1]) == 1:
					connectionFound = true
				if connectionFound:
					levels[pos1[1]][pos1[0]].connectToPosition(pos1,pos2)
					levels[pos2[1]][pos2[0]].connectToPosition(pos2,pos1)
					break
			if connectionFound: break
		
		if connectionFound:
			var island1 = islands.pop_front()
			var island2 = islands.pop_front()
			islands.append(island1+island2)
		else:
			islands.shuffle()
		
		endcase -=1
		if endcase < 0: break
	#print(islands.size())

func _mapIsland(x,y):
	var connections = [[x,y]]
	var checkedTiles = []
	var island = []

	while connections.size() > 0:
		if checkedTiles.find(connections[0]) == -1:
			var chX = connections[0][0]
			var chY = connections[0][1]
			connections = connections + levels[chY][chX].getConnectingTiles([chX,chY])
			island.append(connections[0])
			checkedTiles.append(connections[0])
			connections.pop_front()

		else:
			connections.pop_front()
	#print( island )
	return island

func _getTileNumber (tile):
	match tile.connections:
		# all tiles with 3 or more connections
		[true,true,true,true]:
			return 0
		[true,true,true,false]:
			return 8
		[true,true,false,true]:
			return 7
		[true,false,true,true]:
			return 10
		[false,true,true,true]:
			return 9
		# tiles with 2 connections
		[true,true,false,false]:
			return 6
		[true,false,false,true]:
			return 5
		[false,true,true,false]:
			return 4
		[false,false,true,true]:
			return 3
		[true,false,true,false]:
			return 2
		[false,true,false,true]:
			return 1
		#one connection tiles
		[true,false,false,false]:
			return 12
		[false,true,false,false]:
			return 13
		[false,false,true,false]:
			return 14
		[false,false,false,true]:
			return 11
		#no connections
		[false,false,false,false]:
			return 15
	return -1

func _drawMap(tilemap):
	for y in height:
		for x in width:
			tilemap.set_cell(x,y,_getTileNumber(levels[y][x]))

