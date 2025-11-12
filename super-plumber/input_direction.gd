class_name InputDirection

## The device being read
var device := 0

# Define the actions to be read by this handler
var action_left  := &"ui_left"
var action_right := &"ui_right"
var action_down  := &"ui_down"
var action_up    := &"ui_up"


# Store the state of actions
var _state_left  := 0.0
var _state_right := 0.0
var _state_down  := 0.0
var _state_up    := 0.0


## Try to handle an input event.
## Will return true if the event was handled, false otherwise.
func try_handle_input(event: InputEvent) -> bool:
	if device == event.device:
		# Joystick input may match multiple actions at once
		var read := false
		if event.is_action(action_left):
			_state_left = event.get_action_strength(action_left)
			read = true
		if event.is_action(action_right):
			_state_right = event.get_action_strength(action_right)
			read = true
		if event.is_action(action_down):
			_state_down = event.get_action_strength(action_down)
			read = true
		if event.is_action(action_up):
			_state_up = event.get_action_strength(action_up)
			read = true
		return read
	return false


## Use the stored state to return a vector representing the direction selected.
func get_direction() -> Vector2:
	var x := _state_right - _state_left
	var y := _state_up    - _state_down
	return Vector2(x, y).limit_length()


## Reset the internal state of the handler.
func reset() -> void:
	_state_left  = 0.0
	_state_right = 0.0
	_state_down  = 0.0
	_state_up    = 0.0
