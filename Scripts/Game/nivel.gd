extends Control

# este código lleva la lógica del juego en su estado final (grid ya generado)
# La idea es que todos los subniveles se sucedan en la misma instancia de Nivel


#var victory = false
var next = false
var backwards = false


var n_errorL = 0 # errores del subnivel

var n_errorT = 0 # errores totales de la sesión


#var sblvl = 0 # subnivel
var aciertos = 0

#var lvl = Main.lvl # nivel en el que se encuentra el jugador
#var totalP = Main.totalP # número de aciertos necesarios



var grid = null #guarda el nivel (lvl) de la fase
var pause = false
#var panel = load("res://TSCN/panel_juego.tscn").instantiate()

var menu = false

var infoBut 
var drawing = false # interpreta cuándo se está pintando
var spotted = false # interpreta si se ha presionado una casilla correcta
var stopdraw = false
var crossing = false

var hovering = false
var hoveredButton = null
var lasthoveredButton = null
var removeCross = false # o añadir cruces, o quitarlas

@onready var transitionsPlayer = $AnimationPlayer
@onready var hoverSoundPlayer = $Audio/Hover
@onready var panel = $Tablero/Control/PanelJuego

func _ready() -> void:
	
	Main.totalP = 0
	Main.pauseTimer = false
	#Main.mode = "Infinito"
	
	grid = nextLevel()
	
	#transitionsPlayer.play("Phase"+str(Main.actualPhase))

	
	Main.boardSize = len(grid)
	
	panel.createButtons()
	panel.createGuides()
	
	
	
	
	

func _process(delta: float) -> void:
	
	
	updateLabels()
	#print(transitionsPlayer.get_playing_speed())
	
	if Main.pauseTimer == false:
		Main.tiempoT = Main.phys_contador(delta,Main.tiempoT,60)
		Main.tiempoL = Main.phys_contador(delta,Main.tiempoL,60)
	
	if aciertos != 0 and aciertos == Main.totalP:
		
		# guardar

		pause = true
		aciertos = 0
		Main.totalP = 0
		Main.lvl += 1
		
		
		#if len(grid) == 1:
			#
			#grid = randomLevel(grid[0][0])
			
		
		

		transitionsPlayer.play("Victory")
		backwards = false
		#transitionsPlayer.connect("animation_started",self)

		
	if $UI/ResetButton.button_pressed and next == true: # Fin de Local
			
			#Input.is_action_just_pressed("mouseLeft")
			n_errorL = 0
			Main.tiempoL = {"horas":0,"minutos":0,"segundos":0}
			next = false
			
			grid = nextLevel()
			
			if grid == null: # final del juego
				transitionsPlayer.play("EndGame")
				
			else:
				transitionsPlayer.play_backwards("Victory")
				backwards = true
				
				panel.createButtons(self)
				panel.createGuides()
			
			if Main.mode == "Historia":
				
				Main.infoLVL.append([Main.tiempoL,n_errorL])

			
			#panel.restartScene()
			
			#panel.createButtons(self)
			#$Victory/ResetButton.disabled
			
			#Main.boardSize = grid[lvl]
	if Input.is_action_just_pressed("ui_end") and $UI.get_node("Menu") == null:
		
		menu = true
		Main.pauseTimer = true
		var pauseMenu = load("res://TSCN/UI/pause_menu.tscn").instantiate()
		pauseMenu.name = "Menu"
		$UI.add_child(pauseMenu)
	
	
	
	if Input.is_action_pressed("mouseLeft"):
		
		if stopdraw == false:
			drawing = true
		
	if Input.is_action_just_released("mouseLeft"):
		
		drawing = false
		stopdraw = false
	#
	#if infoBut != null:
		#
		#if drawing:
			#
			#if infoBut[0] == 1 and spotted:
				#
				#aciertos += 1

				#hoveredButton.disabled = true
				#hoveredButton.set("theme_override_styles/focus",StyleBoxEmpty.new())
				#spotted = false
				#
			#if infoBut[0] == 0: # si ha dejado de encontrar correctos
				#drawing = false
				#stopdraw = true
				#n_errorL += 1
				#n_errorT += 1
	
	#if infoBut != null:
		#
		#if infoBut[0] == 1 and drawing: # acierto # botonHover = 4 -> fila = 2 -> grid[lvl][2][4]
			#

			#
			#pass
			##theme_override_styles.disabled_mirrored.bg_color = grid[hoveredButton.get_index()][1] # extrae el color del grid
			#
		#elif drawing:
			#
			#n_errorL += 1
			#n_errorT += 1
			#drawing = false
	if Input.is_action_just_released("mouseRight"): # coloca cruces
			#print("A")
			crossing = false
	
	if hovering: # si se está encima de un botón
		
		if Input.is_action_just_pressed("mouseLeft"):
			
			
			_paint(hoveredButton)

		if Input.is_action_pressed("mouseRight"): # coloca cruces # hay do estados; quitar cruz y colocar cruz
			
			if !hoveredButton.disabled: # si el botón está activado
				markCrosses()
			
			
					
			
					#hoveredButton.get_node("Cross").visible = !hoveredButton.get_node("Cross").visible

	
		


func markCrosses():
	
	var cross = hoveredButton.get_node("Cross")
	
	if crossing == false: # la primera cruz
				
		
		$Audio/Cross.play()
		
		if cross.visible == true: # si la primera cruz es visible
			#print("A")
			removeCross = true #
				
		else:
			removeCross = false
		
		crossing = true
		
	else: 
		
		if removeCross: # mientras se está ponendo cruces
			
			cross.visible = false
		if removeCross == false:
			cross.visible = true

func updateLabels() -> void: # etiquetas de la interfaz

	$UI/Phase.text = str(Main.actualPhase)
	$UI/NvLabel.text = str(Main.lvl+1) # +1 para ajustarse al ojo (0 para índices de array)
	$UI/ErrLabelL.text = str(n_errorL)
	$UI/ErrLabelT.text = str(n_errorT)
	
	
	#$UI/TimeT.text = str(Main.tiempoT["horas"])+" : "+str(Main.tiempoT["minutos"])+" : "+str(Main.tiempoT["segundos"])
	$UI/TimeL.text = str(Main.tiempoL["horas"])+" : "+str(Main.tiempoL["minutos"])+" : "+str(Main.tiempoL["segundos"])
	
func _paint(button: Button) -> void:
	
	
	if button.disabled: # significa que ya ha sido presionado
		return
	
	
	infoBut = grid[button.get_index()] # ! Aquí puede saltar un error a veces. ¿Qué lo causa?
	
	if infoBut[0] == 1: # correcto
		aciertos += 1
		button.disabled = true
		button.get_node("Cross").visible = false
		button.set("theme_override_styles/focus", StyleBoxEmpty.new())
	else: # error
		
		$Audio/Fail.play()
		n_errorL += 1
		n_errorT += 1
		button.get_node("Cross").visible = true
		
		var eco = load("res://TSCN/SFX/eco.tscn").instantiate()
		
		
		eco.get_node("AnimationPlayer").animation_finished.connect(_ecofinished.bind(eco))


		eco.global_position = button.global_position
		
		$SFX.add_child(eco)
		
		
		stopdraw = true  # Bloquea la pintura (hold) si comete un error

func _on_hover(button: Button) -> void: # al pasar encima de cualquier botón
	
	hoverSoundPlayer.play()
	hovering = true
	hoveredButton = button
	
	#hoveredButton = button
	
	if drawing and stopdraw == false:
		
		_paint(button)
		

func _on_exit(_button: Button) -> void:
	
	hovering = false
	lasthoveredButton = hoveredButton

func _on_pressed(_button: Button) -> void: # al presionar cualquier botón
	# presionar espera a que se levante el botón...
	
	pass
	#if stopdraw == false:
		#_paint(button)
		
	
	#if hoveredButton != null: # interpreta el botón que va a ser presionado
		#
		#infoBut = grid[hoveredButton.get_index()] # [Respuesta],[Color]
		#spotted = true
		#
		#if infoBut[0] == 1:
			#aciertos += 1
			#hoveredButton.disabled = true
			#hoveredButton.set("theme_override_styles/focus",StyleBoxEmpty.new())
		#else:
			#n_errorL += 1
			#n_errorT += 1

	#if infoBut != null:
		#
		#if infoBut[0] == 1 and drawing:
			#
			#aciertos += 1
			
			#hoveredButton.disabled = true
			#hoveredButton.set("theme_override_styles/focus",StyleBoxEmpty.new())
	
#func _on_gui_input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
		#
		#if event.button_index == MOUSE_BUTTON_LEFT:
			#drawing = true
			
		
	
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		#
		#if hoveredButton != null:
			#hoveredButton.icon = true
	
func _ecofinished(_anim_name: String, eco):
	
	eco.queue_free()

func nextLevel(): # determina fase de juego
	
	match Main.mode:
		
		"Historia":
			
			if Main.lvl >= len(Main.phases[Main.actualPhase]): # si ya no hay más niveles, cambio de fase
					
				Main.actualPhase += 1
				#transitionsPlayer.play("Phase"+str(Main.actualPhase))
					
				Main.lvl = 0
					
				Main.applyPhase(Main.actualPhase,$Fondo) # aplica en el tablero las características de la fase
			
			print(Main.actualPhase,len(Main.phases))
			if Main.actualPhase == len(Main.phases): # mientras haya fases
				
				print("No hay más fases")
				return null
				
			else:
				
				grid = Main.phases[Main.actualPhase][Main.lvl]
				
				
				print(len(grid))
				if len(grid) == 1: # si el nivel tiene el formato: [[5]]
					
					grid = Main.randomLevel(grid[0][0]) # random de 5x5
			
					
				
		"Infinito":
			
			grid = Main.randomLevel(randi_range(3,5)) # 3x3 , 5x5
			
		"Constructor":
			pass
	
	Main.boardSize = len(grid)

	
	return grid

func _on_animation_player_animation_finished(anim_name: StringName) -> void: # inicio del fin de local
	
	if anim_name == "EndGame":
		get_tree().change_scene_to_file("res://TSCN/UI/EndCredits.tscn")
		
	if anim_name == "Victory" and backwards == false: # si la animación se realiza normal (antes de que aparezca el botón)
		
		
		panel.restartScene()

		next = true
		
