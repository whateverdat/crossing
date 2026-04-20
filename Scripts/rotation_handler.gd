extends AnimatedSprite2D

@export var path_follower : PathFollow2D
@export var signal_sprite : AnimatedSprite2D

const SIGNAL_INTERVAL : float = 0.5
var signal_elapsed : float = 0

const TOTAL_FRAMES = 16
const SLICE = TAU / TOTAL_FRAMES 
const EAST_FRAME_INDEX = 0 

# Lower = slower, Higher = faster rotation
@export var rotation_smoothing := 10.0

var smoothed_angle : float = 0.0


func _ready() -> void:
	if path_follower:
		smoothed_angle = path_follower.rotation


func _process(delta: float) -> void:
	if (signal_sprite):
		_handle_signal_blinking(delta)
		if (path_follower.progress_ratio >= 0.5):
			signal_sprite.hide()
		
	smoothed_angle = lerp_angle(smoothed_angle, path_follower.rotation, rotation_smoothing * delta)
	rotation = -path_follower.rotation
	
	var normalized_rot = fposmod(smoothed_angle, TAU)
	var raw_index = int(round(normalized_rot / SLICE))
	
	frame = posmod(EAST_FRAME_INDEX - raw_index, TOTAL_FRAMES)
	
	if (signal_sprite):
		signal_sprite.rotation = -path_follower.rotation
		signal_sprite.frame = posmod(EAST_FRAME_INDEX - raw_index, TOTAL_FRAMES)
	
func _handle_signal_blinking(delta : float) -> void:
	signal_elapsed += delta
	if (signal_elapsed >= SIGNAL_INTERVAL):
		signal_elapsed = 0
		if (signal_sprite.is_visible_in_tree()):
			signal_sprite.hide()
		else: signal_sprite.show()
