extends RigidBody2D

@export var repell_radius: float = 100.0
@export var repell_strength: float = 50.0

var mouse_repell_radius = 300.0
var mouse_repell_strength = 0.4

@export var radius = 10

# Farger for ulike hastigheter
var color  = Color("#14D2FF")
@export var slow_color: Color = Color("#0286fa")
@export var mid_color: Color = Color("#FFD166") 
@export var fast_color: Color = Color("#FF7B5A")
@export var max_speed: float = 2000.0


func _draw():
	draw_circle(Vector2.ZERO, radius, color)

func _ready():
	add_to_group("particles")
	#collision_shape_2d.shape.radius = radius

#var duration = 5.0
#var start_color = Color(0,0,1)
#var end_color = Color(1,0,0)
#var time = 0

func _physics_process(delta):
	var skip = (randi() % 2) == 0
	if skip:
		return
		
	self.linear_velocity *= 0.95
	
	var particles = get_tree().get_nodes_in_group("particles")
	for particle in particles:
		if particle == self:
			continue

		var to_other = particle.global_position - global_position
		var distance = to_other.length()
		if distance == 0:
			continue

		if distance < repell_radius:
			var direction = to_other.normalized()
			var force = -direction * (repell_radius - distance) * repell_strength
			apply_central_force(force)
	
	var pos = global_position
	var velocity = linear_velocity
	var screen_size = get_viewport_rect().size
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		skip = (randi() % 2) == 0
		if skip:
			return
		var mouse_pos = get_global_mouse_position()
		#draw_circle(mouse_pos, mouse_repell_radius, color) #funker ikke :(
		for particle in particles:
			var to_mouse = particle.global_position - mouse_pos
			var distance = to_mouse.length()
			if distance < mouse_repell_radius:
				var direction = to_mouse.normalized()
				var force = direction * (mouse_repell_radius - distance) * mouse_repell_strength
				particle.apply_central_force(force)
		
	# høyre og venstre vegg
	if pos.x - radius < 0:
		pos.x = radius
		velocity.x *= -1
	elif pos.x + radius > screen_size.x:
		pos.x = screen_size.x - radius
		velocity.x *= -1
	
	#top og bunn vegg
	if pos.y - radius < 0:
		pos.y = radius
		velocity.y *= -1
	elif pos.y + radius > screen_size.y:
		pos.y = screen_size.y - radius
		velocity.y *= -1
	
	global_position = pos
	linear_velocity = velocity
	
	#lerp farge med fart
	var speed = velocity.length()
	var t  = clamp(speed / max_speed, 0.0, 1.0)
	
	if t < 0.5:
		color = slow_color.lerp(mid_color, t * 7.0)
	else:
		color = mid_color.lerp(fast_color, t * 2.0)
	
	queue_redraw()
