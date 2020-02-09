#Program written by Robert aka Sinist and or Sinist75
extends Panel
var totalexp
var maxEXP = 1000 #what is needed to hit the next level
var current = 0 #current exp of player
var lvl = 1
func _on_Button_pressed():
	#turning the strings into ints	
	var playerLVL = float(get_node("Player").get_text())
	var enemyLVL = float(get_node("Enemy").get_text())
	#can't earn exp bellow 0 or excede 300
	totalexp = clamp(enemyLVL/playerLVL*50, 0, 1000)
	#accumalates the total amount of the exp
	current += totalexp
	
	#leveling up and the new current exp
	if(current > maxEXP || current == maxEXP):
		current = current-maxEXP
		lvl += 1
	
	#print the current level
	get_node("level").set_text(String(lvl))
	#print total exp gathered
	get_node("exp gathered").set_text(String(current))
	#print exp
	get_node("expnum").set_text(String(totalexp))
	pass