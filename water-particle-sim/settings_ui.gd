extends CanvasLayer

@onready var panel               = $Panel
@onready var repell_str_slider   = $Panel/VBoxContainer/RepellStrengthSlider
@onready var repell_rad_slider   = $Panel/VBoxContainer/RepellRadiusSlider
@onready var mouse_str_slider    = $Panel/VBoxContainer/MouseStrengthSlider
@onready var friction_slider     = $Panel/VBoxContainer/FrictionSlider
@onready var gravity_slider      = $Panel/VBoxContainer/GravitySlider

@onready var repell_strength_label_value: Label = $"Panel/VBoxContainer/HBoxContainer/RepellStrengthLabel value"
@onready var repell_radius_label_value: Label = $"Panel/VBoxContainer/HBoxContainer4/RepellRadiusLabel value"
@onready var mouse_strength_label_value: Label = $"Panel/VBoxContainer/HBoxContainer3/MouseStrengthLabel value"
@onready var friction_label_value: Label = $"Panel/VBoxContainer/HBoxContainer2/FrictionLabel value"
@onready var gravity_label_value: Label = $"Panel/VBoxContainer/HBoxContainer5/GravityLabel value"


var manager

func setup(m):
	manager = m
	repell_str_slider.value  = manager.repell_strength
	repell_rad_slider.value  = manager.repell_radius
	mouse_str_slider.value   = manager.mouse_repell_strength
	friction_slider.value    = get_tree().get_nodes_in_group("particles")[0].velocity_mod
	gravity_slider.value     = manager.gravity

func _input(event):
	if event.is_action_pressed("settings_ui"):
		panel.visible = !panel.visible

func _on_repell_strength_changed(value):
	if manager:
		manager.repell_strength = value
		repell_strength_label_value.text = str(value)

func _on_repell_radius_changed(value):
	if manager:
		manager.repell_radius = value
		manager.cell_size = value
		repell_radius_label_value.text = str(value)

func _on_mouse_strength_changed(value):
	if manager:
		manager.mouse_repell_strength = value
		mouse_strength_label_value.text = str(value)

func _on_friction_changed(value):
	for p in get_tree().get_nodes_in_group("particles"):
		p.velocity_mod = value
	friction_label_value.text = str(value)

func _on_gravity_changed(value):
	if manager:
		manager.gravity = value
		gravity_label_value.text = str(value)
