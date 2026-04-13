extends Node2D

@export var repell_radius: float = 50.0
@export var repell_strength: float = 600.0
@export var mouse_repell_radius: float = 300.0
@export var mouse_repell_strength: float = 100.0
@export var gravity: float = 200.0

var particles: Array = []

var grid := {}
var cell_size: float
var screen_size: Vector2 = Vector2.ZERO

func _ready():
	await get_tree().process_frame
	particles = get_tree().get_nodes_in_group("particles")
	cell_size = repell_radius
	screen_size = get_viewport_rect().size

	for p in particles:
		p.screen_size = screen_size


func get_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		int(pos.x / cell_size),
		int(pos.y / cell_size)
	)


func _physics_process(delta):
	var radius_sq = repell_radius * repell_radius

	grid.clear()

	for particle in particles:
		var cell = get_cell(particle.global_position)
		if not grid.has(cell):
			grid[cell] = []
		grid[cell].append(particle)

	# Tyngdekraft
	if gravity != 0.0:
		var grav_force = Vector2(0, gravity)
		for particle in particles:
			particle.apply_force(grav_force, delta)

	# Musefrastøting
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and get_viewport().gui_get_hovered_control() == null:
		var mouse_pos = get_global_mouse_position()
		var mouse_radius_sq = mouse_repell_radius * mouse_repell_radius

		for particle in particles:
			var to_mouse = particle.global_position - mouse_pos
			var dist_sq = to_mouse.length_squared()

			if dist_sq < mouse_radius_sq and dist_sq > 0:
				var distance = sqrt(dist_sq)
				var direction = to_mouse / distance
				var force = direction * (mouse_repell_radius - distance) * mouse_repell_strength
				particle.apply_force(force, delta)

	# Partikkel-interaksjoner (én gang per par)
	for cell in grid.keys():
		var cell_particles = grid[cell]

		var neighbors: Array = []
		for x in range(-1, 2):
			for y in range(-1, 2):
				var neighbor_cell = cell + Vector2i(x, y)
				if grid.has(neighbor_cell):
					neighbors += grid[neighbor_cell]

		for particle_a in cell_particles:
			for particle_b in neighbors:
				if particle_a.get_instance_id() >= particle_b.get_instance_id():
					continue

				var to_other = particle_b.global_position - particle_a.global_position
				var dist_sq = to_other.length_squared()

				if dist_sq > 0 and dist_sq < radius_sq:
					var distance = sqrt(dist_sq)
					var direction = to_other / distance
					var force_mag = (repell_radius - distance) * repell_strength
					var force = direction * force_mag

					particle_a.apply_force(-force, delta)
					particle_b.apply_force(force, delta)

	# Oppdater alle partikler
	for particle in particles:
		particle.update(delta)

	queue_redraw()


func _draw():
	for particle in particles:
		draw_circle(particle.global_position, particle.radius, particle.color)
