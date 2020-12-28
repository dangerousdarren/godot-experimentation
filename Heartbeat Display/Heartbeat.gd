extends Node2D


# Declare member variables here. Examples:
var iTime = []
var iHeartSpeed = []


# Called when the node enters the scene tree for the first time.
func _ready():
	var file = loadFile()
	var placemarker = 11#position of first heartrate number
	var length = 1
	while file.substr(placemarker + length - 1,1) != ",":
		length += 1
	#established length to the comma, reduce it by one to knock the comma off
	length -= 1
	var heartRate = [int(file.substr(placemarker,length))]
	while placemarker <= file.length():
		while file.substr(placemarker,1) != "\n" and placemarker <= file.length(): #work to next end of line
			placemarker += 1
		placemarker = placemarker + 11 #next heartrate in string
		if placemarker >= file.length(): break
		length = 1
		while file.substr(placemarker + length - 1,1) != ",":
			length += 1
		length -= 1
		heartRate.append([int(file.substr(placemarker,length))])
	get_node("Time").text = String(placemarker)
	get_node("Heartrate").text = String(heartRate[5])


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func loadFile():
	var file = File.new()
	file.open("res://heartbeat.txt", File.READ)
	#var line1 = file.get_csv_line(",")
	var content = file.get_as_text()
	file.close()
	return content
	
#func _draw():
	
	
#func _process(delta):
#	update()
