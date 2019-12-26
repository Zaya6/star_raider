extends KinematicBody2D

var map
var moveTarget = Vector2(0,0)
var oldMoveTarget
var isActing = false
var isMoving = false

# Called when the node enters the scene tree for the first time.
func _ready():
	map = $"../Map"
	#reset position to be within map cell and set same as initial target move
	moveTarget = map.map_to_world( map.world_to_map( get_position() ) ) + Vector2(32,32) 
	set_position(moveTarget)
	
	set_process_input(true)


func _process(delta):
	$"../postLayer/ripplePlusBack".material.set_shader_param("cameraPosition", $Camera2D.get_camera_position() )
#	$"../postLayer/sparkles".process_material.set_shader_param("cameraPosition", $Camera2D.get_camera_position() )
	if isActing:
		
		if isMoving:
			var pos = get_position()
			var moveVector = (moveTarget-pos).normalized() * 200 * delta
			if (moveTarget-pos).length() < moveVector.length():
				set_position(moveTarget)
				isMoving = false
				isActing = false
			elif move_and_collide( moveVector ):
				moveTarget = oldMoveTarget
			
	if not isActing:
		var moveVector = Vector2.ZERO
		if Input.is_action_pressed("ui_right"):
			moveVector += Vector2(64,0) 
		if Input.is_action_pressed("ui_left"):
			moveVector += Vector2(-64,0) 
		if Input.is_action_pressed("ui_up"):
			moveVector += Vector2(0,-64) 
		if Input.is_action_pressed("ui_down"):
			moveVector += Vector2(0,64) 
		if Input.is_action_pressed("ui_upright"):
			moveVector += Vector2(64,-64) 
		if Input.is_action_pressed("ui_upleft"):
			moveVector += Vector2(-64,-64) 
		if Input.is_action_pressed("ui_downleft"):
			moveVector += Vector2(-64,64) 
		if Input.is_action_pressed("ui_downright"):
			moveVector += Vector2(64,64)
		if Input.is_mouse_button_pressed(1):
			moveVector = map.world_to_map( get_local_mouse_position() + Vector2(32,32) ) * 64
		
		_tryMove( Vector2( clamp(moveVector.x, -64, 64), clamp(moveVector.y, -64, 64) ) )

func _input(event):
	pass


func _tryMove(moveVector:Vector2):
	if !isActing and moveVector.length() != 0:
		if map.get_cellv(map.world_to_map(get_position() + moveVector)) != -1:
			isActing = true
			isMoving = true
			oldMoveTarget = moveTarget
			moveTarget = get_position() + moveVector