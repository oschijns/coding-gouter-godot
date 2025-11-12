class_name InputBuffer

# Handle both pre-buffering and coyote-time for a single input button.
# For example, this module allow properly handling "Jump" inputs.
# When the player is airborne and presses the "Jump" button just before touching the
# floor, this handler will still trigger a jump, even though the press was too early.
# When the player just fell off a cliff and then pressed the "Jump" button,
# the handler will still trigger a jump even though the press was too late.

## Signal that the action controlled by this buffered input can be triggered
signal trigger_action

## The device being read
var device := 0

## The name action being read by this handler
var action_name := &"ui_select"

## Countdown delays for pre-buffering in milliseconds
var countdown_prebuffer := 200

## Countdown delays for coyote-time milliseconds
var countdown_coyote := 200

## Current pressed state of the input (read only)
var is_pressed := false

# Flag that indicates we are in a state where the action can be triggered
var _allow_action := false

# Timestamps for handling pre-buffering and coyote time
var _timestamp_prebuffer := 0
var _timestamp_coyote    := 0


## Try to handle an input event.
## Will return true if the event was handled, false otherwise.
func try_handle_input(event: InputEvent) -> bool:
	if device == event.device and not event.is_echo():
		# check if the button is being pressed
		if event.is_action_pressed(action_name, true):
			is_pressed = true

			var now := Time.get_ticks_msec()
			# check if we were recently in a state when the action could be performed
			if _allow_action or countdown_coyote > now - _timestamp_coyote:
				reset()
				trigger_action.emit()
			else:
				# start the pre-buffering countdown
				_timestamp_prebuffer = now
			return true

		elif event.is_action_released(action_name, true):
			is_pressed = false
			return true

	return false


## Specify that the state has been changed thus allowing (or not) triggering the action
func update_state(new_state: bool) -> void:
	# check that the state was actually changed
	if new_state != _allow_action:
		_allow_action = new_state

		var now := Time.get_ticks_msec()
		if not new_state:
			# start the coyote-time countdown
			_timestamp_coyote = now
		# check if we pressed the input in the last few frames
		elif countdown_prebuffer > now - _timestamp_prebuffer:
			reset()
			trigger_action.emit()


## Reset internal timers
func reset() -> void:
	_allow_action        = false
	_timestamp_prebuffer = 0
	_timestamp_coyote    = 0
