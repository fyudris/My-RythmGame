extends AnimatedSprite2D

#  Track the timing accuracy of the player's input relative to the note's position.
var perfect = false
var good = false
var okay = false

# Stores the currently active note (the note the player is trying to hit)
var current_note = null

# The specific input (such as a key press or controller button) that triggers the note hit.
@export var input = ""

#  Handles input when a player presses a key (or action) that corresponds to the note.
func _unhandled_input(event: InputEvent) -> void:
	# Detect the action only once when pressed (no echo)
	if Input.is_action_just_pressed(input):
		if current_note != null:
			if perfect:
				get_parent().increment_score(3)
				current_note.destroy(3) #Show label "Perfect
			elif good:
				get_parent().increment_score(2)
				current_note.destroy(2) #Show label "Good
			elif good:
				get_parent().increment_score(2)
				current_note.destroy(2)
			elif okay:
				get_parent().increment_score(1)
				current_note.destroy(1)
			_reset()
		else:
			get_parent().increment_score(0)
		# Detects the action continuously while the button is held down (with echo)
		if Input.is_action_pressed(input):
			frame = 1 # Changes the sprite frame to give feedback to the player that a button was pressed.
			# TODO: Check animation frame
		elif event.is_action_released(input):
			$PushTimer.start() #Starts a timer to reset the sprite after the key is released.
	
func _reset():
	current_note = null
	perfect = false
	good = false
	okay = false

# Resets the sprite's animation to default frame
func _on_push_timer_timeout() -> void:
	frame = 0

func _on_perfect_area_area_entered(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		perfect = true

func _on_perfect_area_area_exited(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		perfect = false


func _on_good_area_entered(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		good = true

func _on_good_area_exited(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		good = false

func _on_okay_area_area_entered(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		okay = true
		current_note = new_note #Make sure current note is handled in case of multiple consecutive notes


func _on_okay_area_area_exited(new_note: Area2D) -> void:
	if new_note.is_in_group("note"):
		okay = false
		current_note = null
