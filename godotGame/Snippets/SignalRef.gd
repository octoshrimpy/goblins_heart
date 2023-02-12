extends Node2D

#Sample Signal Stuff

class Whatever:
#declare signal
	signal signalName(optional, params)
#with no params
	signal noParams

#Emit signal (Class.emit_signal("signalName") ) 
func signalCorps():
	Whatever.emit_signal("signalName")

#Connect and listen (observe) for signal, and callback if true
func _ready():
	if not Events.is_connected("signalName", self, "_callbackMethodName"):
			Events.connect("signalName", self, "_callbackMethodName")
			print('connected signal')
