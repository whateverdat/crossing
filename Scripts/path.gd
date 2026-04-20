extends PathFollow2D

enum CarState { MOVING, STOPPED }
const MIN_SPEED : int = 0
const MAX_SPEED : float = 25

var speed : float = 25
var acceleration : float = 50

var state : CarState = CarState.MOVING

func _ready() -> void:
	pass
	
func _process(delta) -> void:
	if (state == CarState.MOVING):
		if (speed < MAX_SPEED):
			speed += acceleration * delta
			if (speed > MAX_SPEED): speed = MAX_SPEED
			
	else:
		if (speed > MIN_SPEED):
			speed -= acceleration * delta
			if (speed < MIN_SPEED): speed = MIN_SPEED
			
	progress += delta * speed
	
func handle_clicked() -> void:
	if (state == CarState.MOVING):
		state = CarState.STOPPED
	else: state = CarState.MOVING
	
	
