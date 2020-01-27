extends Area2D

func _ready():
	if ST.currentLevel != null:
		set_position(ST.currentLevel.resetPositionToMap(get_position())+Vector2(0,2))
		

func _on_itemSack_body_entered(body):
	if body.is_in_group("player"):
		ST.gameUI.addGroundItem(name, self)

func _on_itemSack_body_exited(body):
	if body.is_in_group("player"):
		ST.gameUI.removeGroundItem(name)
		
func getIcon():
	return $Sprite.texture
	

func activate():
	print_debug(name)
