extends Control

#var l_set = false
var languages = TranslationServer.get_loaded_locales()
#var l = 0

var l = 0
var lmin = 0
var lmax = len(languages)-1
#var info

var move = false
var offset : Vector2


func _ready():
	
	#Main.pauseTimer = true
	
	l = languages.find(SO.lang)
	
	$Opciones/Audio/Music.value = Main.Music_db
	$Opciones/Audio/Sound.value = Main.Sound_db
	$Opciones/Idioma/Language.text = Main.idioma
	$Opciones/TimeJ.text = str(Main.tiempoJ["horas"])+" : "+str(Main.tiempoJ["minutos"])
	
	$AnimationPlayer.play("pop")
	
	if $Niveles.visible:
		
		for i in Main.infoLVL: # [t,err]
			
			var storylvl = load("res://TSCN/UI/StoryLVL.tscn").instantiate()
			
			$Niveles/GridContainer.add_child(storylvl)
			
			
			for t in i[0].values(): # {h:"",m:"",s:""}
				
				storylvl.get_node("Time").text += str(t)
			
			storylvl.get_node("Error").text = str(i[1])


func _process(_delta):
	
	
	
	if move:
		
		if Input.is_action_just_pressed("mouseLeft"): # nada más clickar corrige la posición
			
			offset = get_global_mouse_position() - self.global_position
			
		if Input.is_action_pressed("mouseLeft"):
			
			self.global_position = get_global_mouse_position() - offset
	
	
	
			
	#$Idioma/Language.text = languages[l]
	

	

		#if Input.is_action_just_pressed("ui_left") and l != 0:
			#l -= 1
		#if Input.is_action_just_pressed("ui_right") and l < len(languages)-1:
			#l += 1
#
		#if Input.is_action_just_pressed("ui_accept"):
			#Main.idioma = languages[l]
			#var datos = Main.save_config()
			#
			#Main.Set_default_config(datos)
#
			#hide()
			#l_set = true
			#get_parent().get_node("Musica").stream_paused = false


func _on_close_pressed() -> void:
	
	$AnimationPlayer.play_backwards("pop")
	await $AnimationPlayer.animation_finished # detiene el código mientras la animación se esté ejecutando
	
	queue_free()


func _on_left_pressed() -> void:
	
	if lmin < l:
		l -= 1
	else:
		l = lmax # va al final

	
	SO.changeLang(languages[l])
	$Opciones/Idioma/Language.text = Main.idioma

func _on_right_pressed() -> void:
	
	if l < lmax:
		l += 1
	else:
		l = 0 # va al principio
	
	
	SO.changeLang(languages[l])
	$Opciones/Idioma/Language.text = Main.idioma

func _on_sup_bar_mouse_entered() -> void: # permite mover la ventana
	
	move = true
	
	


func _on_sup_bar_mouse_exited() -> void:
	
	move = false


func _on_music_value_changed(value: float) -> void:
	
	Main.Music_db = $Opciones/Audio/Music.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),Main.Music_db)
	

func _on_sound_value_changed(value: float) -> void:
	
	Main.Sound_db = $Opciones/Audio/Sound.value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"),Main.Sound_db)
