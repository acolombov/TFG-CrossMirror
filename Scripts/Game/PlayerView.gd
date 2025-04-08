extends Node2D


onready var lim_left = get_parent().get_node("Limits/Left")
onready var lim_right = get_parent().get_node("Limits/Right")

onready var camera = get_parent().get_node("Camera2D")
var ok = false # si ok el código funciona



signal out_ # el cursor está fuera
signal in_

# ! Problema: Si el cursor empieza fuera cursor_freedom se toma como 'false' por defecto

func _ready():
	pass

func _process(_delta):
	#print(interact_area)
	
	if Main.cursor_freedom:
		camera.limit_bottom = lim_right.global_position.y
		camera.limit_right = lim_right.global_position.x
		camera.limit_top = lim_left.global_position.y
		camera.limit_left = lim_left.global_position.x
	
		if Main.input_vector == Vector2(0,0): # la camara sigue al cursor
			camera.global_position = get_global_mouse_position()
#	var mouse_offset = (get_viewport().get_mouse_position() - get_viewport().size / 2)
#	$CanvasLayer/Camera2D.position = lerp(Vector2(), mouse_offset.normalized() * 500, mouse_offset.length() / 1000)


#func _on_Immobile_mouse_exited():
#	ok = true
#	emit_signal("out_")
#
#
#
#
#
#func _on_Immobile_mouse_entered(): # la cámara vuelve a su posición original
#	ok = false
#	print("b")
#	emit_signal("in_")
#	camera.get_node("Tween").start()
#	camera.get_node("Tween").interpolate_property(camera,"position:x",camera.global_position.x,get_parent().position.x,0.5)
#	camera.get_node("Tween").interpolate_property(camera,"position:y",camera.global_position.y,get_parent().position.y,0.5)
#	#interpolate_property(audio.get_node("Illumination"),"volume_db",audio.get_node("Illumination").volume_db,0,2)



#
#func _on_Spot_in_():
#	ok = false
#	print("a")
#
#
#func _on_Spot_out_():
#	ok = true
#
#
#func _on_Spot2_in_():
#	ok = false
#
#
#func _on_Spot2_out_():
#	ok = true


func _on_Immobile_area_entered(area):
	if area.get_name() == "Cursor":
		Main.cursor_freedom = false
		#emit_signal("in_")
		
		Main.interact_area = get_node("/root/World").objeto

		if Main.interact_area != null:
			print("ok")
			camera.get_node("Tween").start()
			camera.get_node("Tween").interpolate_property(camera,"position:x",camera.global_position.x,Main.interact_area.get_parent().position.x,0.5)
			camera.get_node("Tween").interpolate_property(camera,"position:y",camera.global_position.y,Main.interact_area.get_parent().position.y,0.5)



func _on_Immobile_area_exited(area):
	if area.get_name() == "Cursor":
		Main.cursor_freedom = true
		Main.interact_area = null
