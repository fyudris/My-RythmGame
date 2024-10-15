extends Area2D

# Vertical Positions
var SPAWN_Y
var TARGET_Y
var DIST_TO_TARGET

# Horizontal Positions
var MARKER_X_POST = null

# Note Configuration
var hit = false
var bpm = 86 # Example BPM, adjust this based on the actual song BPM
var time_per_beat = 60.0 / bpm
var speed = 0


const LEFT_LANE = 0
const DOWN_LANE = 1
const UP_LANE = 2
const RIGHT_LANE = 3


func _ready() -> void:
	# Get the screen height dynamically
	var screen_height = ProjectSettings.get_setting("display/window/size/viewport_height")
	
	# Calculate spawn and target Y positions based on viewport height
	SPAWN_Y = screen_height * 1.05 # Spawn 5% below the bottom of the screen
	TARGET_Y = screen_height * 0.1 # 10% from the top of the screen
	
	# Calcualte distance between spawn and target
	DIST_TO_TARGET = SPAWN_Y - TARGET_Y
	
	speed = DIST_TO_TARGET / time_per_beat
	
	# Dynamically retrieve the X-positions of the 4 AnimatedSprite2D markers
	MARKER_X_POST = [
		get_node("/root/Game/MarkerLeft").global_transform.origin.x,
		#get_node("/root/Game/MarkerDown").global_transform.origin.x,
		#get_node("/root/Game/MarkerUp").global_transform.origin.x,
		#get_node("/root/Game/MarkerRight").global_transform.origin.x
	]
	

func _physics_process(delta: float) -> void:
	if !hit:
		position.y -= speed * delta
		if position.y < -$AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame).get_height():
			queue_free()
			print("Destroyed")


func configure_arrow_rotation(marker_index):
	# Set the position based on which marker (target arrow) the note corresponds to.
	match marker_index:
		LEFT_LANE:
			$AnimatedSprite2D.rotation_degrees = 90
		DOWN_LANE:
			$AnimatedSprite2D.rotation_degrees = 0
		UP_LANE:
			$AnimatedSprite2D.rotation_degrees = 180
		RIGHT_LANE:
			$AnimatedSprite2D.rotation_degrees = -90
		_:
			printerr("Invalid marker index: " + str(marker_index))
			return
	# Set the arrow position based on the marker index and spawn point
	position = Vector2(MARKER_X_POST[marker_index], SPAWN_Y)

func destroy(score):
	#$CPUParticles2D.emitting = true
	$AnimatedSprite2D.visible = false
	$Timer.start()
	hit = true
	if score == 3:
		$Node2D/Judgement.text = "GREAT"
		$Node2D/Judgement.modulate = Color("f6d6bd")
	elif score == 2:
		$Node2D/Judgement.text = "GOOD"
		$Node2D/Judgement.modulate = Color("c3a38a")
	elif score == 1:
		$Node2D/Judgement.text = "OKAY"
		$Node2D/Judgement.modulate = Color("997577")

func _on_timer_timeout() -> void:
	queue_free()
