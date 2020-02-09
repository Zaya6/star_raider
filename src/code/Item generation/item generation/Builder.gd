#code created by Robert Griffin(AKA Sinist75, AKA Sinist) january-febuary of 2020
class_name Builder
var numGen = RandomNumberGenerator.new()
var itemType = [["health",10],["mana",10]]
#[health/mana][value]
var size = [["bag",1],["small bag",.5],["large bag",2]]
#[size][multiplier]

func _init(sd=1234):
	if sd ==1234: numGen.randomize()
	else: numGen.set_seed(sd)
	pass

func getFullItem():
	var itemMade = Item.new()    #object
	var type = numGen.randi() % 2    #deciding if it is mana or health
	itemMade.type = itemType[[type][0]]    #getting the name of type
	
	var die = numGen.randi() % 30    #deciding on if it is a small, regular, or large bag
	if die < 10 || die == 10:   #if small
		itemMade.size = size[[0][0]]
	if die > 10 && die < 21:   #regular bag
		itemMade.size = size[[1][0]]
	if die > 20:
		itemMade.size = size[[2][0]]
	#calculating the amount aplied
	itemMade.amt = itemMade.type[1]*itemMade.size[1]
	return itemMade

#func ranselect(arry = [], Minnimum = 0, offset = 0):
#	return arry[numGen.randi_range(Minnimum, arry.size()-1-offset)]