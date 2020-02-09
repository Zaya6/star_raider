extends Node2D

var origins = []
var returnOrigin = false
var fadeBlack = false
var bColor = Vector3(1,1,1)

func _init():
	var size = OS.get_screen_size() if OS.window_fullscreen or OS.window_maximized else OS.window_size
	var basis = size.x if size.x > size.y else size.y
	ST.scaleRatio = 64.0/basis as float

func _ready():
	set_layout()
	
	# collisions seem to change when the random num gen is randomized
	randomize()
	
	# sort to seperate pixels so they don't collide
	var ySort = Vector2(0,0)
	#go through pixels, get origin and move to teleport
	for pixel in $pixelstage.get_children():
		#get origins and move above screen
		origins.append(pixel.get_position())
		pixel.set_global_position($teleport.get_global_position()+ySort)
		# apply random rotation and velocity
		pixel.angular_velocity = rand_range(-10,10)
		pixel.apply_central_impulse( Vector2(0,1500) ) 
		ySort.y -= 50

func _process(delta):
	
	if returnOrigin:
		#index for pixel origins
		var i = 0
		for pixel in $pixelstage.get_children():
			pixel.rotation = 0; pixel.sleeping = true
			pixel.set_position( pixel.position.linear_interpolate(origins[i],0.1)  )
			i+=1
		
	if fadeBlack:
		bColor = bColor.linear_interpolate(Vector3(0,0,0),0.1)
		$background/cover.material.set_shader_param("color", bColor)
		$lettering.set_modulate( $lettering.get_modulate().linear_interpolate( Color(1,1,1,1), 0.1 ) );
	

func set_layout():
	var screen = get_viewport_rect().size
	var center = screen / 2
	var pStagePos = Vector2(center.x, center.y/2.5)
	$pixelstage.set_position(pStagePos)
	$lettering.set_position(pStagePos)
	$teleport.position.x = center.x
	
	#collision bounds
	$collision/bottom.set_position(Vector2(center.x,screen.y))
	$collision/right.set_position(Vector2(screen.x+128, 0))
	$collision/left.set_position(Vector2(-128, 0))

func _on_returnPixels_timeout():
	returnOrigin = true
	
func _on_fadeBlack_timeout():
	fadeBlack = true
	$exitScene.start()
	
func _on_exitScene_timeout():
	get_tree().change_scene("res://test/RegionTest.tscn")
