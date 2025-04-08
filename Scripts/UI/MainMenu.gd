extends Control

#onready var selector = get_node()

var ended = false

@onready var anim_player = $Fondo/AnimationPlayer
@onready var datasave = Main

var pasa = false
var info 

var pitch_theme

func _ready():
	
	Main.pauseTimer = true
	

func _process(_delta):
	
	
	
	if len(Main.infoLVL) > 0:
		
		$Botones/LevelsB.disabled = false
		$UI/ActualLevel.text = str(len(Main.infoLVL))
		
	if Input.is_action_just_pressed("mouseLeft"):
		
		var _mouse_pos = get_viewport().get_mouse_position()
		
		#fondo.material.set_shader_parameter("wave_origin", mouse_pos)
		#fondo.material.set_shader_parameter("wave_time", 0.0)  # Reinicia la onda

func _physics_process(_delta):
	pass
	#var time = fondo.material.get_shader_parameter("wave_time")
	#fondo.material.set_shader_parameter("wave_time", time + delta)  # Expande la onda


func _on_new_b_pressed() -> void: # partida nueva y reanudar
	
	# reanudar la partida guardando toda la información (paneles encontrados, cruces...)
	if len(Main.infoLVL) > 0:
		pass
	
	get_tree().change_scene_to_file("res://TSCN/Modos/Nivel.tscn")
	Main.mode = "Historia"
	
	

func _on_infinite_pressed() -> void: # paneles infinitos, de tamaño variable. Totalmente aleatorio
	
	get_tree().change_scene_to_file("res://TSCN/Modos/Nivel.tscn")
	Main.mode = "Infinito"

func _on_constructor_b_pressed() -> void: # paneles generativos, creados mediante reglas por el jugador
	
	get_tree().change_scene_to_file("res://TSCN/Modos/CreadorPaneles.tscn") # el cambio de escena elimina self

func _on_options_b_pressed() -> void:
	
	SO.openWindow("Opciones",get_node("UI"))


func _on_exit_b_pressed() -> void:
	queue_free()
	get_tree().quit()


func _on_levels_b_pressed() -> void:
	
	SO.openWindow("Niveles",get_node("UI"))
