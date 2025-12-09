extends Node2D

const PARTICLE_SCENE = preload("res://particle.tscn")
@export var num_particles: int = 250

var screen_height = 1080 / 2
var screen_width = 1920 / 2
@export var spawn_area: Rect2 = Rect2(Vector2(0, 0), Vector2(screen_width, screen_height))


func _ready():
	DisplayServer.window_set_size(Vector2i(screen_width, screen_height))
	Engine.physics_ticks_per_second = 100
	Engine.time_scale = 1.0
	
	for i in num_particles:
		var p = PARTICLE_SCENE.instantiate()
		var rand_pos = Vector2(
			randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
			randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
		)
		p.global_position = rand_pos
		add_child(p)
