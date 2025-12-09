extends Node2D

@export var repell_radius: float = 80.0
@export var repell_strength: float = 50.0
@export var mouse_repell_radius: float = 300.0
@export var mouse_repell_strength: float = 100.0

var particles: Array = []

func _ready():
	# Samle alle partikler ved oppstart
	await get_tree().process_frame
	particles = get_tree().get_nodes_in_group("particles")

func register_particle(particle):
	if not particles.has(particle):
		particles.append(particle)

#func unregister_particle(particle):
	#particles.erase(particle)

func _physics_process(delta):
	# Håndterer musinteraksjon
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		for particle in particles:
			if not is_instance_valid(particle):
				continue
				
			var to_mouse = particle.global_position - mouse_pos
			var distance = to_mouse.length()
			
			if distance < mouse_repell_radius and distance > 0:
				var direction = to_mouse.normalized()
				var force = direction * (mouse_repell_radius - distance) * mouse_repell_strength
				particle.apply_central_force(force)
	
	# Beregn alle partikkel-partikkel interaksjoner
	for i in range(particles.size()):
		var particle_a = particles[i]
		if not is_instance_valid(particle_a):
			continue
			
		# Sjekk bare partikler som ikke er segselv
		for j in range(i + 1, particles.size()):
			var particle_b = particles[j]
			if not is_instance_valid(particle_b):
				continue
				
			#regner distanse og retning mellom partikler
			var to_other = particle_b.global_position - particle_a.global_position
			var distance = to_other.length()
			
			#sjekker om et partikkel er nerme nokk til å dyttes vekk
			if distance > 0 and distance < repell_radius:
				var direction = to_other.normalized()
				var force_magnitude = (repell_radius - distance) * repell_strength
				
				#Påfører samme kraft på begge partiklere i motsatt rettning. 
				particle_a.apply_central_force(-direction * force_magnitude)
				particle_b.apply_central_force(direction * force_magnitude)
