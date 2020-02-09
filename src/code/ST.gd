extends Node
# A singleton class that holds information used between scenes
var gameUI = null

# playerDepth is a gage in how far in generation the player is located. Each successive number represents the following
#   [current region, current level, cave/dungeon system.....]
#    * this way the game always knows which level to load when moving depths and where the player entered from
var playerDepth = 0
var playerPositions = {0:Vector2(0,0)}
var gameSeed = 0
var rand = RandomNumberGenerator.new()
var scaleRatio = 1

var currentLevel:Level = null
var currentRegion: Region = null
var currentPlayer: PlayerController = null
var tree = null

# Need to transition most things to this
var settings = {
	"logbarOpen": true,
	"groundViewerOpen": true,
	"showGeneration": true
}

func _init():
	# get a scale ratio based on resolution
	# for things like zoom, etc
	var size = OS.get_screen_size() if OS.window_fullscreen or OS.window_maximized else OS.window_size
	var basis = size.x if size.x > size.y else size.y
	scaleRatio = 64.0/basis as float

