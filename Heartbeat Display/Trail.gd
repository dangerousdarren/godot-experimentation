extends Line2D

var length = 150
var point = Vector2()
var horizontalLength = 10
var lineTop
var currentHorizontalPos = 170
var currentVerticalPos = 300
var step
var startTime
var lineSpeed = 1
var heartRate
var state = 1
var vertCentre = 300
var nextHorizontal
var horizontalStep = 2
var beats = 0
var currentHeartBeat
var file_loaded = false

signal update_heartRate(heartRate)

func _ready():
	var file = loadFile()
	var placemarker = 11#position of first heartrate number
	var string_length = 1
	while file.substr(placemarker + string_length - 1,1) != ",":
		string_length += 1
	#established length to the comma, reduce it by one to knock the comma off
	string_length -= 1
	heartRate = [int(file.substr(placemarker,string_length))]
	while placemarker <= file.length():
		while file.substr(placemarker,1) != "\n" and placemarker <= file.length(): #work to next end of line
			placemarker += 1
		placemarker = placemarker + 11 #next heartrate in string
		if placemarker >= file.length(): break
		string_length = 1
		while file.substr(placemarker + string_length - 1,1) != ",":
			string_length += 1
		string_length -= 1
		heartRate.append(int(file.substr(placemarker,string_length)))

	currentHeartBeat = 0
	startTime = OS.get_ticks_msec()
	global_position = Vector2(0,0)
	global_rotation = 0
	step = heartRate[currentHeartBeat] / 5
	lineTop = vertCentre - heartRate[currentHeartBeat]
	currentVerticalPos = vertCentre + step
	horizontalStep = step / 10
	state = 1
	beats = 0
	file_loaded = true
	emit_signal("update_heartRate",heartRate[currentHeartBeat])

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if file_loaded:
		if OS.get_ticks_msec() - startTime >= lineSpeed:#move line every so often
			startTime = OS.get_ticks_msec()
			if beats > 5: 
				clear_points()
				beats = 0
				currentHorizontalPos = 170
			if state == 1:#Initial going up
				if currentVerticalPos > lineTop:
					currentHorizontalPos += horizontalStep
					currentVerticalPos -= step
				else: state = 2
			if state == 2: #Going down
				var botLine = heartRate[currentHeartBeat]
				if currentVerticalPos < vertCentre + botLine:
					currentHorizontalPos += horizontalStep
					currentVerticalPos += step
				else: state = 3
			if state == 3: #Going back up to centre
				if currentVerticalPos > vertCentre:
					currentHorizontalPos += horizontalStep
					currentVerticalPos -= step
					nextHorizontal = currentHorizontalPos + horizontalLength
				else: state = 4
			if state == 4: ##Horizontal a little bit
				if currentHorizontalPos < nextHorizontal:
					currentHorizontalPos += horizontalStep 
				else: state = 5
			if state == 5: #Up a little bit
				if currentVerticalPos > vertCentre - step:
					currentHorizontalPos += horizontalStep
					currentVerticalPos -= step
					nextHorizontal = currentHorizontalPos + horizontalLength
				else: state = 6
			if state == 6: #along a bit & down
				if currentHorizontalPos < nextHorizontal:
					currentHorizontalPos += horizontalStep 
					currentVerticalPos += step /2
				else: 
					nextHorizontal = currentHorizontalPos + horizontalLength * 3
					state = 7
			if state == 7: #along a little bit
				if currentHorizontalPos < nextHorizontal:
					currentHorizontalPos += horizontalStep * 10
				else: 
					beats += 1
					currentHeartBeat += 1
					emit_signal("update_heartRate",heartRate[currentHeartBeat])
					lineTop = vertCentre - heartRate[currentHeartBeat]
					state = 1
			add_point(point + Vector2(currentHorizontalPos,currentVerticalPos))
			if get_point_count() > length:
				remove_point(0)
			
			
func loadFile():
	var file = File.new()
	file.open("res://heartbeat.txt", File.READ)
	#var line1 = file.get_csv_line(",")
	var content = file.get_as_text()
	file.close()
	return content
