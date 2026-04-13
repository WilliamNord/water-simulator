extends Node2D

@export var radius: float = 10.0

var color: Color = Color("#14D2FF")
@export var slow_color: Color = Color("#0286fa")
@export var mid_color: Color = Color("#FFD166")
@export var fast_color: Color = Color("#FF7B5A")
@export var max_speed: float = 1500.0
@export var velocity_mod: float = 0.97

var velocity: Vector2 = Vector2.ZERO
var screen_size: Vector2 = Vector2.ZERO

func _ready():
	add_to_group("particles")

func apply_force(force: Vector2, delta: float):
	velocity += force * delta

func update(delta: float):
	velocity *= velocity_mod
	global_position += velocity * delta

	var pos = global_position

	if pos.x - radius < 0:
		pos.x = radius
		velocity.x *= -1
	elif pos.x + radius > screen_size.x:
		pos.x = screen_size.x - radius
		velocity.x *= -1

	if pos.y - radius < 0:
		pos.y = radius
		velocity.y *= -1
	elif pos.y + radius > screen_size.y:
		pos.y = screen_size.y - radius
		velocity.y *= -1

	global_position = pos

	# Oppdater farge basert på hastighet
	var speed = velocity.length()
	var t = clamp(speed / max_speed, 0.0, 1.0)

	if t < 0.5:
		color = slow_color.lerp(mid_color, t * 2.0)
	else:
		color = mid_color.lerp(fast_color, (t - 0.5) * 2.0)
