class_name JumpTrajectory

# Compute jump variations from four parameters
# - height  The height of the peak of the jump
# - time    The time to reach that peak
# - impulse The initial vertical velocity
# - gravity The gravity force

# Epsilon value used through the engine
const EPSILON := 1e-5


#region ATTRIBUTES

## The height of the peak of the jump
var height := 1.0:
	set(value):
		height = maxf(value, EPSILON)

## The time to reach that peak
var time := 1.5:
	set(value):
		time = maxf(value, EPSILON)

## The initial vertical velocity
var impulse := 0.4:
	set(value):
		impulse = maxf(value, EPSILON)

## The gravity force
var gravity := -0.04:
	set(value):
		gravity = minf(value, -EPSILON)

#endregion


#region METHODS
# Compute parameters from attributes stored

func compute_from_height_and_time():
	impulse = impulse_from_height_and_time(height, time)
	gravity = gravity_from_height_and_time(height, time)

func compute_from_height_and_impulse():
	time    =    time_from_height_and_impulse(height, impulse)
	gravity = gravity_from_height_and_impulse(height, impulse)

func compute_from_height_and_gravity():
	time    =    time_from_height_and_gravity(height, gravity)
	impulse = impulse_from_height_and_gravity(height, gravity)

func compute_from_time_and_impulse():
	height  =  height_from_time_and_impulse(time, impulse)
	gravity = gravity_from_time_and_impulse(time, impulse)

func compute_from_time_and_gravity():
	height  =  height_from_time_and_gravity(time, gravity)
	impulse = impulse_from_time_and_gravity(time, gravity)

func compute_from_impulse_and_gravity():
	height = height_from_impulse_and_gravity(impulse, gravity)
	time   =   time_from_impulse_and_gravity(impulse, gravity)

#endregion


#region STATICS
# Functions that compute a full set of parameters from two
# Resulting vectors contain
# - x: height
# - y: time
# - z: impulse
# - w: gravity

static func from_height_and_time(height_: float, time_: float) -> Vector4:
	assert(0.0 <  height_,  "Height cannot be null or negative")
	assert(0.0 <    time_,    "Time cannot be null or negative")
	return Vector4(
		height_, 
		time_, 
		impulse_from_height_and_time(height_, time_), 
		gravity_from_height_and_time(height_, time_))

static func from_height_and_impulse(height_: float, impulse_: float) -> Vector4:
	assert(0.0 <  height_,  "Height cannot be null or negative")
	assert(0.0 < impulse_, "Impulse cannot be null or negative")
	return Vector4(
		height_, 
		time_from_height_and_impulse(height_, impulse_), 
		impulse_, 
		gravity_from_height_and_impulse(height_, impulse_))

static func from_height_and_gravity(height_: float, gravity_: float) -> Vector4:
	assert(0.0 <  height_,  "Height cannot be null or negative")
	assert(0.0 > gravity_, "Gravity cannot be null or positive")
	return Vector4(
		height_, 
		time_from_height_and_gravity(height_, gravity_), 
		impulse_from_height_and_gravity(height_, gravity_), 
		gravity_)

static func from_time_and_impulse(time_: float, impulse_: float) -> Vector4:
	assert(0.0 <    time_,    "Time cannot be null or negative")
	assert(0.0 < impulse_, "Impulse cannot be null or negative")
	return Vector4(
		height_from_time_and_impulse(time_, impulse_), 
		time_, 
		impulse_, 
		gravity_from_time_and_impulse(time_, impulse_))

static func from_time_and_gravity(time_: float, gravity_: float) -> Vector4:
	assert(0.0 <    time_,    "Time cannot be null or negative")
	assert(0.0 > gravity_, "Gravity cannot be null or positive")
	return Vector4(
		height_from_time_and_gravity(time_, gravity_), 
		time_, 
		impulse_from_time_and_gravity(time_, gravity_), 
		gravity_)

static func from_impulse_and_gravity(impulse_: float, gravity_: float) -> Vector4:
	assert(0.0 < impulse_, "Impulse cannot be null or negative")
	assert(0.0 > gravity_, "Gravity cannot be null or positive")
	return Vector4(
		height_from_impulse_and_gravity(impulse_, gravity_), 
		time_from_impulse_and_gravity(impulse_, gravity_), 
		impulse_, 
		gravity_)

#endregion


#region FORMULAS
# Simple functions for computing one parameter from two others


# Height
static func height_from_time_and_impulse(time_: float, impulse_: float) -> float:
	return 0.5 * impulse_ * time_

static func height_from_time_and_gravity(time_: float, gravity_: float) -> float:
	return -0.5 * gravity_ * time_ ** 2

static func height_from_impulse_and_gravity(impulse_: float, gravity_: float) -> float:
	return -0.5 * impulse_ ** 2 / gravity_


# Time
static func time_from_height_and_impulse(height_: float, impulse_: float) -> float:
	return 2.0 * height_ / impulse_

static func time_from_height_and_gravity(height_: float, gravity_: float) -> float:
	return sqrt(2 * height_ / gravity_)

static func time_from_impulse_and_gravity(impulse_: float, gravity_: float) -> float:
	return -impulse_ / gravity_


# Impulse
static func impulse_from_height_and_time(height_: float, time_: float) -> float:
	return 2.0 * height_ / time_

static func impulse_from_height_and_gravity(height_: float, gravity_: float) -> float:
	return sqrt(2.0 * height_ * gravity_)

static func impulse_from_time_and_gravity(time_: float, gravity_: float) -> float:
	return -gravity_ * time_


# Gravity
static func gravity_from_height_and_time(height_: float, time_: float) -> float:
	return -2.0 * height_ / time_ ** 2

static func gravity_from_height_and_impulse(height_: float, impulse_: float) -> float:
	return -0.5 * impulse_ ** 2 / height_

static func gravity_from_time_and_impulse(time_: float, impulse_: float) -> float:
	return -impulse_ / time_


# Range & Speed
static func time_from_range_and_speed(range_: float, speed_: float, ratio_ := 0.5) -> Vector2:
	var time_ := range_ / speed_
	return Vector2(time_ * ratio_, time_ * (1.0 - ratio_))


#endregion
