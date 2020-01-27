extends EntityController

var moveVector = Vector2(0,0)
var mouseDown = false

# overwrite entity turn processing, because turns 
# start from the player
func executeTurn()->void:
	pass
	
func _onMoveEnded():
	if moveVector == Vector2.ZERO:
		$Particles2D.emitting = false
		_anim.play("idle")
	else: 
		_isMoving = true
		_moveByTile(moveVector)
		
	endTurn()

func endTurn():
	if ST.currentLevel != null:
		ST.currentLevel.executeTurns()

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				mouseDown = true
			else:
				mouseDown = false

func _process(delta):
	moveVector = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		moveVector.x += 1
	if Input.is_action_pressed("ui_left"):
		moveVector.x += -1 
	if Input.is_action_pressed("ui_up"):
		moveVector.y += -1 
	if Input.is_action_pressed("ui_down"):
		moveVector.y += 1 
	if Input.is_action_pressed("ui_upright"):
		moveVector = Vector2(1,-1)
	if Input.is_action_pressed("ui_upleft"):
		moveVector = Vector2(-1,-1)
	if Input.is_action_pressed("ui_downleft"):
		moveVector = Vector2(-1,1) 
	if Input.is_action_pressed("ui_downright"):
		moveVector = Vector2(1,1)
	if mouseDown:
		var v = _map.world_to_map( get_local_mouse_position() + Vector2(32,32) ) * 64
		moveVector = Vector2( clamp(v.x, -1, 1), clamp(v.y, -1, 1) )
	
	if not _isMoving:
		if moveVector != Vector2.ZERO:
			_moveByTile(moveVector)