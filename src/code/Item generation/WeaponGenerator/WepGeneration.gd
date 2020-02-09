#This code was written by Robert Griffin (aka Sinist. aka Sinist75) from December 2019 to january 2020
class_name WepGeneration
var numGen = RandomNumberGenerator.new()
var weapons = [["sword", 10], ["axe", 20], ["spear", 30], ["mace", 40],["staff", 50]]
var dmg
#elements and their damage
const FIRE = 0
const ICE = 1
const POISON = 2
const DARK = 3
const LIGHT = 4
var elementals = [ 
	[["Blazing",1.5],["Burning",1.6],["Smoking",1.7],["infernal",1.8],["combustion",1.9]], #fire
	[["Glacial",1.5],["Hailstone",1.6],["Icicle",1.7],["Snowy",1.8],["Floe",1.9]], #ice
	[["Corrosive",1.5],["Blight",1.6],["Miasma",1.7],["Venomous",1.8],["Acidic",1.9]], #poison
	[["Spiteful",1.5],["Dusky",1.6],["Twilight",1.7],["Gloom",1.8],["Murky",1.9]], #dark
	[["Glowing",1.5],["Daybreaker",1.6],["Radiant",1.7],["Brilliant",1.8],["Virtous",1.9]], #light
	]
#conditions weapon type
const FLAW = 0
const COMMON = 1
const EXQUISITE = 2
const IMPECABLE = 3
const ANGELIC = 4
var rarety = [
	[["rusted",-1], ["Chipped",-2], ["Crumbling",-3], ["Cracked",-4], ["Peeling",-5], ["Dull",-6], ["Bent",-7], ["Dented",-8], ["Scratched",-9], ["Marred",-10], ["Smashed",-10], ["Scarred",-10], ["Subpar",-10], ["standard",-10]], #flawed
	[["Decent",24], ["Sharpened",25], ["Vital",26], ["Essential",27], ["Good",28], ["Useful",29], ["Primitive",30], ["Average",31], ["Honest",32], ["Superb",33], ["New",34], ["Unscathered",35], ["Flawless",36], ["Shining",37], ["Primary",38]], #common
	[["Shining",39], ["Upgraded",40], ["Improved",41] ,["Great",42], ["Plus",43], ["Intreguing",44], ["Pointy",45] ,["Extra-sharp",46], ["Modified",47], ["Practiced",48], ["Saught-after",49], ["Limited",50], ["Strange",51], ["Uncommon",52], ["Unique",53], ["Attenuated",54]], #exquisite
	[["Fabled",55], ["Fabulous",56], ["Mythical",57] ,["Mythical",58], ["Storied",59], ["Figmental",60], ["Fanciful",61], ["Dubious",62], ["Mythelogical",63], ["Improbable",64], ["Mythical",65], ["Whimsical",66], ["Razor-sharp",67], ["Keen",68], ["Fine",69], ["Unreal",70], ["metaphorical",71]], #impecable  
	[["Lustrous",72], ["Brilliant",73], ["Splendid",74], ["Outstanding",75], ["Perfect",76], ["Finest",77], ["Ornate",78], ["Dazzling",79], ["Transcendental",80], ["Supernatural",81], ["Mystical",82], ["Magnificant",83], ["Radiant",84], ["Otherworldly",85], ["Etherial",86], ["Celestial",87]], #angelic
	]
#[rareity][rarety scale][0 = rarety name, 1 = calculated variable]

func _init(sd=1234):
	if sd == 1234: numGen.randomize()
	else: numGen.set_seed(sd)
	pass
#creates the full weapon which it terned into an object with three properties, if the property shows up as false the property is null. 
func getFullWeapon():
	var weapon = WeaponItem.new() 
	weapon.type = ranSelect(weapons) 
	#print_debug(weapon.type[0])
	var die = numGen.randi() % 100
	if die < 50:
		weapon.rarety = ranSelect(rarety[0])
	elif die > 51:
		weapon.rarety = getRarety()
		#print_debug(weapon.rarety[0])
		if numGen.randi() % 10  < 5:
			weapon.elemental = getElement()
	dmg = weapon.rarety[1]+weapon.type[1]*weapon.elemental[1]
	#weapon = ("A "+weapon.rarety[0]+" "+weapon.type[0]+" of "+weapon.elemental[0])
	print("A "+weapon.rarety[0]+" "+weapon.type[0]+" of "+weapon.elemental[0])
	print(dmg)
	return weapon
#elemental selection. selects an element in the elemennt multiplier array. 
func getElement():
	var ele = ranSelect(ranSelect(elementals))
	return ele
#raretiy selection. selects an element in the rarety matrix
func getRarety():
	var Rare = ranSelect(ranSelect(rarety,1))
	return Rare
#helps with finding array element. selects a row in the matrix based random dice rolls
func ranSelect(arry = [], Minnimum = 0, offSet = 0):
	return arry[numGen.randi_range(Minnimum, arry.size()-1-offSet)]