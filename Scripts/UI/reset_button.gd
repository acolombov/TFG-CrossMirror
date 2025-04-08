#extends Button
#
#var colors = [Color.WHITE, Color.RED, Color.GREEN, Color.BLUE]
#var current_color_index = 0
#
#signal color_changed(color)
#
#func _ready():
	#_update_color()
#
#func _on_button_pressed():
	#current_color_index = (current_color_index + 1) % colors.size()
	#_update_color()
#
#func _update_color():
	#self.modulate = colors[current_color_index]
	#emit_signal("color_changed", colors[current_color_index])
