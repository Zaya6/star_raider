class_name EntityController
extends KinematicBody2D

var aggression = 0
var fear = 0
var power = 0
var weight = 1
var health = 1


#internal use only
var _debugMap = false
var _anim:AnimationPlayer = null
var state = null
var states = {}
var _attackTarget = null
var _moveTarget = Vector2(0,0)
var _lastPosition = Vector2(0,0)
var _lastMove = Vector2(0,0)
var _speed = 128
var _map:TileMap = null
var _index = 0
var _isMoving = false

#### internal functions

func _init():
	pass

func _ready():
	if ST.currentLevel:
		_map = ST.currentLevel.getMap()
		_index = ST.currentLevel.addEntity(self)
	else:
		_map = TileMap.new()
		_debugMap = true
	_anim = $anim
	_anim.set_blend_time("walk", "idle", 0.1)
	var resetpos = _resetPositionToMap(position)
	_moveTarget = resetpos
	_lastPosition = resetpos
	set_position(resetpos)

#### movement code ####

func _physics_process(delta:float):
	if _moveTarget != position:
		if not _isMoving:
			_isMoving = true
			_onMoveStarted()
		_moveToward(_moveTarget,delta)
	elif _isMoving: #if the first fails, movement must have stopped if _isMoving is true
		_isMoving = false
		_onMoveEnded()

func _moveToward(target:Vector2, delta:float):
	var distance:float = position.distance_to(target)
	var movement:Vector2 = position.direction_to(target) * _speed * delta
	# if the movement is less than the distance to target, 
	# just move fully to target
	if distance < position.distance_to(position+movement): 
		movement = target - position
	
	if move_and_collide(movement):
		#if true, then a collision occured
		# go back to the last position
		_moveTarget = _lastPosition

func _resetPositionToMap(pos:Vector2)->Vector2:
	return _map.map_to_world(_map.world_to_map(pos)) + Vector2(32,32)

func _moveByTile(moveTiles:Vector2)->bool:
	#make sure it's one at a time
	moveTiles.x = clamp(moveTiles.x, -1, 1)
	moveTiles.y = clamp(moveTiles.y, -1, 1)
	
	return _tryMove(moveTiles * Vector2(64,64))

func _tryMove(move:Vector2)->bool:
	#only move when not already moving
	if not _ismoving():
		if not _testMoveBlocked(move):
			_lastPosition = position
			_moveTarget = position + move
			_lastMove = move
			_setArtDirection(move)
			return true
		else:
			return false
	return false

func _testMoveBlocked(move:Vector2)->bool:
	var movePosition = position + move
	#check map first if tile moving to is empty
	if not _debugMap and not _checkTileNav(_map.get_cellv(_map.world_to_map(movePosition))):
		return true
	elif test_move(get_transform(), move, true):
		return true
	return false

func _ismoving()->bool:
	return not position == _moveTarget

func _setArtDirection(movement:Vector2):
	for child in $artCenter/faces.get_children():
		child.hide()
	
	match movement:
		Vector2(0,-64):
			$artCenter/faces/up.show()
		Vector2(64,-64):
			$artCenter/faces/upright.show()
		Vector2(64,0):
			$artCenter/faces/right.show()
		Vector2(64,64):
			$artCenter/faces/rightdown.show()
		Vector2(0,64):
			$artCenter/faces/down.show()
		Vector2(-64,64):
			$artCenter/faces/leftDown.show()
		Vector2(-64,0):
			$artCenter/faces/left.show()
		Vector2(-64,-64):
			$artCenter/faces/upleft.show()
		Vector2(0,0):
			$artCenter/faces.get_children()[randi() % 8].show()

func _checkTileNav(cell:int)->bool:
	match cell:
		-1:
			return false
		16:
			return false
		17:
			return false
		18:
			return false
		19:
			return false
	return true


# helper functions
# callback functions
func _onMoveEnded():
	$Particles2D.emitting = false
	_anim.play("idle")
func _onMoveStarted():
	_anim.play("walk")
	$Particles2D.emitting = true
# outside Functions

func executeTurn()->void:
	if state != null:
		states[state].call_func()
	else:
		nullState()

#### States ####
func nullState():
	wander()

func addState(name:String,stateFunction:FuncRef):
	states[name] = stateFunction
	
# Behavior functions

func moveRandomly()->void:
	var tries = 10
	while tries > 0 and not _moveByTile(Vector2(round(rand_range(-1,1)),round(rand_range(-1,1)))):
		tries -= 1

func wander()->void:
	if _lastMove == Vector2(0,0):
		moveRandomly()
	elif randi() %  10 < 6:
		if not _tryMove(_lastMove):
			moveRandomly()
	else:
		moveRandomly()

