extends Node2D

var origins = []
var pixels = []
var returnOrigin = false
var fadeBlack = false
var showlogo = false

func _ready():
	var teleport_pos = $teleport.get_position()
	var ySort = Vector2(0,0)
	pixels = $pixelstage.get_children()
	for pixel in pixels:
		origins.append(pixel.get_position())
		pixel.set_position(teleport_pos+ySort)
		pixel.angular_velocity = rand_range(-10,10)
		ySort.y -= 50
	pass
	

func _process(delta):
	if returnOrigin:
		var i = 0
		for pixel in pixels:
			pixel.rotation = 0
			pixel.sleeping = true
			pixel.set_position( pixel.position.linear_interpolate(origins[i],0.1)  )
			i+=1
	if fadeBlack:
		var color1 = $backWhite.get_modulate(); color1.a -= 0.05;
		var color2 = $lettering.get_modulate(); color2.a += 0.05;
		$backWhite.set_modulate(color1)
		$lettering.set_modulate(color2)

func _on_returnPixels_timeout():
	returnOrigin = true
func _on_fadeBlack_timeout():
	fadeBlack = true

