extends CanvasLayer

@onready var panel               = $Panel
@onready var repell_str_slider   = $Panel/VBoxContainer/RepellStrengthSlider
@onready var repell_rad_slider   = $Panel/VBoxContainer/RepellRadiusSlider
@onready var mouse_str_slider    = $Panel/VBoxContainer/MouseStrengthSlider
@onready var friction_slider     = $Panel/VBoxContainer/FrictionSlider

var manager

func setup(m):
	manager = m
	# Fyll inn nåværende verdier fra spillet
	repell_str_slider.value  = manager.repell_strength
	repell_rad_slider.value  = manager.repell_radius
	mouse_str_slider.value   = manager.mouse_repell_strength
	friction_slider.value    = get_tree().get_nodes_in_group("particles")[0].velocity_mod

func _input(event):
	if event.is_action_pressed("settings_ui"):  # Tab
		panel.visible = !panel.visible

# --- Kobles til value_changed på hver slider ---

func _on_repell_strength_changed(value):
	if manager:
		manager.repell_strength = value

func _on_repell_radius_changed(value):
	if manager:
		manager.repell_radius = value
		manager.cell_size = value  # grid må følge med

func _on_mouse_strength_changed(value):
	if manager:
		manager.mouse_repell_strength = value

func _on_friction_changed(value):
	for p in get_tree().get_nodes_in_group("particles"):
		p.velocity_mod = value
