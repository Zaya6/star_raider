#This code was written by Robert Griffin (aka Sinist. aka Sinist75) from December 2019 to january 2020
class_name WeaponItem
var elemental = ["null", 0]
var type = ["null", 0]
var rarety = ["null",0]

func _init():
	pass

func getName():
	var name = type[0]
	if not rarety[0] == "null":
		name = "A "+ rarety[0] +" "+ name
	if not elemental[0] == "null":
		name = name +" of "+ elemental[0]
	return name
#func getDmg():
#	pass