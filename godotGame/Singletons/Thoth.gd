extends Node2D

#item type enum
enum ITEM_TYPE {CONSUMABLE, WEAPON, ARMOR, TECH, OTHER}
#export (PackedScene) var Item
onready var Item = preload("res://Item/Item.tscn")

#Sample Item(s):
#onready var test_item1 = Item.instance()
#onready var test_item2 = Item.instance().init('test2', 2, 2, 2, 2, 2, 2, 2, true, ITEM_TYPE.OTHER)

var player = {
	stats = {
		hp = 100,
		mana = 100,
		stamina = 100,
		atk = 10,
		def = 10,
		speed = 1,
		knowledge = 0,
		experience = 0
	},
	inventory = {
		#store instanced items in proper arrays
#		consumable = [{item = 'placeholder'}],
#		weapon = [{item = 'placeholder'}],
#		armor = [{item = 'placeholder'}],
#		tech = [{item = 'placeholder'}]
	consumable = [],
		weapon = [],
		armor = [],
		tech = []
	}
}

#get internal player dict/obj, returns whole object
func _get_player():
	return player

func add_to_player_inventory(item, type):
	player['inventory'][type].push_back(item)
	print('current_inventory: ', player['inventory'])
	
func make_item(item_name = 'n/a', hp = 0, mana = 0, 
	#params continue, line breaks
			stamina = 0, atk = 0, def = 0, speed = 0, knowledge = 0, 
			experience = 0, consumable = false, type = ITEM_TYPE.OTHER):
	var new_item = Item.instance()
	new_item.init_item(item_name, hp, mana, stamina, atk, def, speed, knowledge, experience, consumable, type)
	print('new_item check: ', new_item)
	return new_item

#This is just to test my item instancing is working and unique
func make_items():
	var test_item1 = Item.instance()
	var test_item2 = Item.instance()
	test_item1.init('test1', 1000)
	test_item2.init('test2')
	return [test_item2.data, test_item1.data]
#

func test_items_unique():
	var items = make_items()
	print('item1:', items[0])
	print('item2:', items[1])
	var test_item3 = Item.instance()
	test_item3.init()
	test_item3.get_value('item_name')
	test_item3.set_value('item_name', 'test success!')
	test_item3.get_value('item_name')
	test_item3.get_keys()
	test_item3.get_size()
	
func _ready():
	pass
	


