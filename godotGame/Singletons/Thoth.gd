extends Node2D

onready var timer = $Timer

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
#This is just to test my item instancing is working and unique
func make_items():
	var test_item1 = Item.instance()
	var test_item2 = Item.instance()
	test_item1.init('test1', 1000)
	test_item2.init('test2')
	return [test_item2.data, test_item1.data]
#
func _ready():
	pass
#	var items = make_items()
#	print('item1:', items[0])
#	print('item2:', items[1])
#	var test_item3 = Item.instance()
#	test_item3.init()
#	test_item3.get_value('item_name')
#	test_item3.set_value('item_name', 'test success!')
#	test_item3.get_value('item_name')
#	test_item3.get_keys()
#	test_item3.get_size()
	
func _on_Timer_timeout():
	print('time timeout happened!')
	Chronos.test_me()


