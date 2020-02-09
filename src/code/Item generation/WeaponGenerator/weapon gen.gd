#This code was written by Robert Griffin (aka Sinist. aka Sinist75) from December 2019 to january 2020
extends Panel

func _ready():
	var wepGen = WepGeneration.new() #creates a weapon that has three properties. 
	print(wepGen.getFullWeapon())
	pass
