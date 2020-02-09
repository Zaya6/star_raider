tool
extends Node

export(String, FILE, "*.json") var StampLibraryPath
export(String) var stampName = ""
export(Vector2) var Probability = Vector2(1,1)
export(int) var limitSpawns = -1
export(bool) var rotation = false
export(bool) var turnOff = false
export(bool) var removeStamp = false
export(bool) var saveStamp = false

#internal variables
var stampData = {}

func _ready():
	pass

func _process(delta):
	pass
	if saveStamp:
		saveStamp()
		saveStamp = false
	if removeStamp:
		removeStamp()
		removeStamp = false

func removeStamp():
	var library = []
	var newLibrary = []
	var file = File.new()
	
	if file.file_exists(StampLibraryPath):
		print("existing library found, loading...")
		file.open(StampLibraryPath, file.READ_WRITE)
		library = parse_json(file.get_as_text())
		file.close()
		
		# loop through library and remove stamp
		for stamp in library:
			if stamp["name"] != stampName:
				newLibrary.append(stamp)
			else:
				print("removing stamp from library")

		file.open(StampLibraryPath, file.WRITE)
		file.store_string(to_json(newLibrary))
		file.close()
	else:
		print("library doesn't yet exist, no changes made'")

func saveStamp():
	print("saving stamp")
	var pKey = []
	var sKey = []
	var pattern = $Pattern
	var stamp = $Stamp
	
	for pos in pattern.get_used_cells():
		var cell = pattern.get_cellv(pos)
		if cell == 1: cell = -1
		pKey.append([int(pos.x),int(pos.y),cell])
	for pos in stamp.get_used_cells():
		var cell = stamp.get_cellv(pos)
		if cell == 1: cell = -1
		sKey.append([int(pos.x),int(pos.y),cell])
	
	stampData = {
		name = stampName,
		pattern_key = pKey,
		stamp_key = sKey,
		pattern_width = pattern.width,
		pattern_height = pattern.height,
		stamp_width = stamp.width,
		stamp_height = stamp.height,
		prob = [Probability.x,Probability.y],
		limit = limitSpawns,
		totalSpawns = 0,
		active = not turnOff,
		rotate = rotation,
		lastSeed = 0
		}
	print("storing stamp data")
	
	writeToFile()

func writeToFile():
	var library = []
	var file = File.new()
	
	#check if the library already exists
	if file.file_exists(StampLibraryPath):
		print("existing library found, loading...")
		file.open(StampLibraryPath, file.READ)
		library = parse_json(file.get_as_text())
		file.close()
	
	file.open(StampLibraryPath, file.WRITE)
	library = replace(library, stampData)
	file.store_string(to_json(library))
	file.close()
	print("stamp saved")

func replace(array, data):
	var newArray = [data]
	for value in array:
		if value["name"] != data["name"]:
			newArray.push_back(value)
	return newArray
