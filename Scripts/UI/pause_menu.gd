extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	Main.pauseTimer = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("ui_end") or Input.is_action_just_pressed("mouseRight"):
		Main.pauseTimer = false
		queue_free()

func _on_resume_pressed() -> void:
	self.queue_free()


func _on_exit_b_pressed() -> void: # salir al menú
	
	get_tree().change_scene_to_file("res://TSCN/UI/MainMenu.tscn")


func _on_options_b_2_pressed() -> void:
	
	SO.openWindow("Opciones",self)
