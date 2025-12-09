extends RigidBody2D

@export var radius = 12

# Farger for ulike hastigheter
var color = Color("#14D2FF")
@export var slow_color: Color = Color("#0286fa")
@export var mid_color: Color = Color("#FFD166") 
@export var fast_color: Color = Color("#FF7B5A")
@export var max_speed: float = 2000.0


func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func _ready():
	add_to_group("particles")

func _physics_process(delta):
	self.linear_velocity *= 0.95
	
	var pos = global_position
	var velocity = linear_velocity
	var screen_size = get_viewport_rect().size
	
	# Veggkollisjoner
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
	linear_velocity = velocity
	
	# Oppdater farge basert på hastighet
	var speed = velocity.length()
	var t = clamp(speed / max_speed, 0.0, 1.0)
	
	if t < 0.5:
		color = slow_color.lerp(mid_color, t * 2.0)
	else:
		color = mid_color.lerp(fast_color, (t - 0.5) * 2.0)
	
	queue_redraw()
