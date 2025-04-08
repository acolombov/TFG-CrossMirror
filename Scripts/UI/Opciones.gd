extends Control

var n_opt

func _ready():
	$Pop1.modulate = Color(0,0,0,0)
	
func _process(_delta):
	
	$Pop2/Sonido/Volumen/Valores/Label1.text = str(Main.numAmb)
	$Pop2/Sonido/Volumen/Valores/Label2.text = str(Main.numS)
	$Pop2/Sonido/Volumen/Valores/Label3.text = str(Main.numMc)
	
	if visible == true and $Pop1.modulate == Color(1,1,1):
		
		if Main.submenu == true and Main.submenu2 == false and $Pop1.modulate == Color(1,1,1):
			menu()


		if Main.submenu2 == true and $Pop2.modulate == Color(1,1,1):
			pos_submenu()

			if Input.is_action_just_pressed("ui_cancel"):
				Main.save_config()
				$AnimationPlayer.play("Exit2")
				await $AnimationPlayer.animation_finished
				Main.submenu2 = false
				Main.pos_y = Main.ultima_pos_y
			
			
			

func menu():
	Main.move_selector(3,0,0,32,$Pop1/Panel/Selector)
	
	if Input.is_action_just_pressed("ui_accept"):
		Main.submenu2 = true
		$Pop2.show()
		
		Main.ultima_pos_y = Main.pos_y
		
		if Main.pos_y == 0: # sonido
			$AnimationPlayer.play("Sonido")
			n_opt = 2
		if Main.pos_y == 1: # controles
			$AnimationPlayer.play("Controles")
			
		if Main.pos_y == 2: # idioma
			$AnimationPlayer.play("Idioma")
			n_opt = 1
		if Main.pos_y == 3: # pantalla
			$AnimationPlayer.play("Pantalla")
			n_opt = 0
		
		Main.pos_y = 0
		$Pop2/Panel/Selector.position.y = 24


func pos_submenu():
	if Main.ultima_pos_y == 1:
		pass
	else:
		Main.move_selector(n_opt,0,0,32,$Pop2/Panel/Selector)
	if Main.ultima_pos_y == 0: # submenu de Volumen

		if Main.pos_y == 0:

			if Input.is_action_just_pressed("ui_right"):
				
				Main.numM = adjust_volume(Main.numAmb,5,"Ambiente",$Move)
			
			if Input.is_action_just_pressed("ui_left"):
				Main.numM = adjust_volume(Main.numAmb,-10,"Ambiente",$Move)
				
		if Main.pos_y == 1: 
			if Input.is_action_just_pressed("ui_right"):
				Main.numS = adjust_volume(Main.numS,5,"Sound",$Move)
				
				
			if Input.is_action_just_pressed("ui_left"):
				Main.numS = adjust_volume(Main.numS,-10,"Sound",$Move)
				
		if Main.pos_y == 2:
			if Input.is_action_just_pressed("ui_right"):
				Main.numMc = adjust_volume(Main.numMc,5,"Music",$Move)
				
			if Input.is_action_just_pressed("ui_left"):
				Main.numMc = adjust_volume(Main.numMc,-10,"Music",$Move)
		
		
		###    ^^^^         Volumen        ^^^^    ###
		###    ||||                        ||||    ###
		
	if Main.ultima_pos_y == 1: # submenu Controles
		pass
		
	if Main.ultima_pos_y == 2: # submenu Idioma
		language()
		$Pop2/Idioma.show()
		

		if Input.is_action_just_pressed("ui_accept") and $Pop2.modulate == Color(1,1,1):

			if Main.pos_y == 0: # Español
				
				TranslationServer.set_locale("es")
				Main.idioma = "es"
				
				
				
				
			if Main.pos_y == 1: # English
				TranslationServer.set_locale("en")
				Main.idioma = "en"
		
		
	###    ^^^^         Idioma         ^^^^    ###
	###    ||||                        ||||    ###
	
	if Main.ultima_pos_y == 3: # submenu Pantalla
		if get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (= true:) else Window.MODE_WINDOWED
				$Pop2/Idioma/Active.modulate = Color(1,1,1)
		else:
			$Pop2/Idioma/Active.modulate = Color(0,0,0)
		if Input.is_action_just_pressed("ui_accept") and $Pop2.modulate == Color(1,1,1):
			get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
			

func adjust_volume(num,lim,bus,rep):
	if lim > 0:
		if num == lim:
			pass
		else:
			num += 1
			
	if lim < 0:
		if num == lim:
			pass
		else:
			num -= 1
	
	if Main.pos_y == 0:
		Main.numAmb = num
	elif Main.pos_y == 1:
		Main.numS = num
	else:
		Main.numMc = num
	get_node("Pop2/Sonido/Volumen/Valores/Label"+str(Main.pos_y+1)).text = str(num)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), num)
	rep.play()
	return num

func language():
	if Main.idioma == "es":
		$Pop2/Idioma/Active.modulate = Color(1,1,1)
		$Pop2/Idioma/Active2.modulate = Color(0,0,0,0.5)

	if Main.idioma == "en":
		$Pop2/Idioma/Active.modulate = Color(0,0,0,0.5)
		$Pop2/Idioma/Active2.modulate = Color(1,1,1)
