extends Node2D


var playback: AudioStreamPlayback = null # Actual playback stream, assigned in _ready().

signal updateBeatsLabel(heartRate)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#global_position = get_global_mouse_position()
#	pass


#func _on_trail_update_heartRate(heartRate):
	#pass # Replace with function body.


func _on_trail_update_heartRate(heartRate):
	emit_signal("updateBeatsLabel",heartRate)
	$Player.set_pitch_scale(float(heartRate) / 100 + .3)
	$Player.play()
	
