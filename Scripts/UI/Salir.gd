extends Control



func _process(_delta):
	if modulate == Color(1,1,1):
		
		Main.move_selector(1,0,0,15,$Panel/Selector) # max y x , mov x y
		if Input.is_action_just_pressed("ui_accept"):
			if Main.pos_y == 0:

				queue_free()
				get_tree().quit()

			if Main.pos_y == 1: # AL menu
				process_mode = Node.PROCESS_MODE_PAUSABLE # para el menu
				Main.main_menu = true
				Main.tp_transition("res://Scenes/UI/MainMenu.tscn",0.5)
				
				
