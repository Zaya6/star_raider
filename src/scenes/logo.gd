extends Node2D

var origins = []
var pixels = []
var returnOrigin = false
var fadeBlack = false

func _init():
	var size = OS.get_screen_size() if OS.window_fullscreen or OS.window_maximized else OS.window_size
	var basis = size.x if size.x > size.y else size.y
	ST.scaleRatio = 64.0/basis as float

func _ready():
	randomize()
	var teleport_pos = $teleport.get_position()
	var ySort = Vector2(0,0)
	pixels = $pixelstage.get_children()
	for pixel in pixels:
		origins.append(pixel.get_position())
		pixel.set_position(teleport_pos+ySort)
		pixel.angular_velocity = rand_range(-10,10)
		pixel.apply_central_impulse( Vector2(0,1500) ) 
		ySort.y -= 50

func _process(delta):
	if returnOrigin:
		var i = 0
		for pixel in pixels:
			pixel.rotation = 0; pixel.sleeping = true
			pixel.set_position( pixel.position.linear_interpolate(origins[i],0.1)  )
			i+=1
	if fadeBlack:
		$backWhite.set_modulate( $backWhite.get_modulate().linear_interpolate( Color(1,1,1,0), 0.1 ) );
		$lettering.set_modulate( $lettering.get_modulate().linear_interpolate( Color(1,1,1,1), 0.1 ) );

func _on_returnPixels_timeout():
	returnOrigin = true
func _on_fadeBlack_timeout():
	fadeBlack = true
func _on_exitScene_timeout():
	get_tree().change_scene("res://test/RegionTest.tscn")
