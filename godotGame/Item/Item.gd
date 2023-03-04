extends Node

#item type enum
enum ITEM_TYPE {CONSUMABLE, WEAPON, ARMOR, TECH, OTHER}

var data = {
	item_name = 'default',
	hp = 100,
	mana = 100,
	stamina = 100,
	atk = 10,
	def = 10,
	speed = 1,
	knowledge = 0,
	experience = 0,
	consumable = false,
	#All lower case versions of enum, 0 - 4
	type = 'other'
}

#Call init after instance to set values
func init_item(item_name = 'n/a', hp = 0, mana = 0, 
	#params continue, line breaks
			stamina = 0, atk = 0, def = 0, speed = 0, knowledge = 0, 
			experience = 0, consumable = false, type = ITEM_TYPE.OTHER):
	#set properties based on default values or provided arguments
	var type_conversion = ''
	match type:
		0: type_conversion = 'consumable'
		1: type_conversion = 'weapon'
		2: type_conversion = 'armor'
		3: type_conversion = 'tech'
		4: type_conversion = 'other'
		_: type_conversion = 'error'
		
	data.item_name = item_name
	data.hp = hp
	data.mana = mana
	data.stamina = stamina
	data.atk = atk
	data.def = def
	data.speed = speed
	data.knowledge = knowledge
	data.experience = experience
	data.consumable = consumable
	data.type = type_conversion
	
#-----------# adds methods for internal object dictionary #---------------------#
func get_keys():
	print(data.keys())
	return data.keys()
	
func get_all_values():
	print(data.values())
	return data.values()

func erase_value(value):
	data[value].erase()
	
func has_value(value):
	return data.has(value)
	
func has_all_values(values_array):
	return data.has_all(values_array)
	
func get_hash():
	print(data.hash())
	return data.hash()
	
func get_size():
	print(data.size())
	return data.size()

func get_value(property_to_get):
	print(data[property_to_get])
	return data[property_to_get]
	
func set_value(property_to_set, value_to_set):
	data[property_to_set] = value_to_set
	print('set ', property_to_set, ' to: ', value_to_set)
#-------------------------------------------------------------------------------#
