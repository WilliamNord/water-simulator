extends Node2D

@export var repell_radius: float = 50.0
@export var repell_strength: float = 600.0
@export var mouse_repell_radius: float = 300.0
@export var mouse_repell_strength: float = 100.0

var particles: Array = []

# Grid
var grid := {}
var cell_size: float

func _ready():
	await get_tree().process_frame
	particles = get_tree().get_nodes_in_group("particles")
	
	# Viktig: cell size bør være lik eller større enn radius
	cell_size = repell_radius


func get_cell(pos: Vector2) -> Vector2i:
	return Vector2i(
		int(pos.x / cell_size),
		int(pos.y / cell_size)
	)


func _physics_process(delta):
	var radius_sq = repell_radius * repell_radius
	
	particles = particles.filter(func(p): return is_instance_valid(p))
	
	grid.clear()
	
	for particle in particles:
		var cell = get_cell(particle.global_position)
		
		if not grid.has(cell):
			grid[cell] = []
			
		grid[cell].append(particle)
	
	# input fra mus
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
				
				particle.apply_central_force(force)
	
	
	for cell in grid.keys():
		
		var cell_particles = grid[cell]
		
		# Finn nabo-celler
		var neighbors := []
		
		for x in range(-1, 2):
			for y in range(-1, 2):
				var neighbor_cell = cell + Vector2i(x, y)
				
				if grid.has(neighbor_cell):
					neighbors += grid[neighbor_cell]
		
		
		# Sjekk interaksjoner
		for particle_a in cell_particles:
			for particle_b in neighbors:
				
				if particle_a == particle_b:
					continue
				
				var to_other = particle_b.global_position - particle_a.global_position
				var dist_sq = to_other.length_squared()
				
				if dist_sq > 0 and dist_sq < radius_sq:
					var distance = sqrt(dist_sq)
					var direction = to_other / distance
					var force_mag = (repell_radius - distance) * repell_strength
					
					var force = direction * force_mag
					
					particle_a.apply_central_force(-force)
					particle_b.apply_central_force(force)
