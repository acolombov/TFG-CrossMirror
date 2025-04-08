extends Node

var mode = null # modo  "Historia", "Constructor", "Infinito"
var colorGame = false
var totalP = 0
var lvl = 0
var pauseTimer = false

#var randMax = randi_range(3,10) #


var boardSize = 0 # guarda el tamaño de grid

var main_menu = true

	

var actualPhase = 0

var phases = [ # [  [ []  ]  ],[] | p[1] = fase 2 | p[4]
	
	[ # Fase 1
	
		[
			[1,Color.BLACK],[1,Color.BLACK],[0,Color.BLACK],[1,Color.BLACK],
			[1,Color.BLACK],[0,Color.BLACK],[1,Color.BLACK],[0,Color.BLACK],
			[1,Color.BLACK],[0,Color.BLACK],[1,Color.BLACK],[0,Color.BLACK],
			[1,Color.BLACK],[1,Color.BLACK],[1,Color.BLACK],[1,Color.BLACK],
		],
		
		[[3]]
	
	],
	[ # F2
		[[4]]
	],
	[ # F3
		[[4]]

	]
	
]

var infoLVL = [] # información de niveles completados [ [tiempo,errores...],[] ] 




@onready var bus = load("res://default_bus_layout.tres")

@onready var timer = Timer.new()


var dlg_activo = false # true si hay un dialogo activo

var save = true

var Master_db = 0 # Master
var Sound_db = 0 # Sound
var Music_db = 0 # Music




var ranura = 0
var idioma = "es"

var tempo = 0 # contador de
#var tempo_cycle = 0
var tiempoJ = {"horas":0,"minutos":0,"segundos":0} # tiempo jugado

var tempoL # tiempo Local
var tiempoL = {"horas":0,"minutos":0,"segundos":0} # tiempo jugado
var tempoT # tiempo Total
var tiempoT = {"horas":0,"minutos":0,"segundos":0} # tiempo local. Se guarda en la información de nivel

var autosave = false


func _ready():
	

	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
		
func _process(delta):
	
	
	

	if pauseTimer == false: # Si no se está en el menú se activa el contador
		tiempoJ = phys_contador(delta,tiempoJ,60)


func applyPhase(phase,nodo):
	
	match  phase:
		0:
			nodo.color = Color.WHITE
		1: # azul
			nodo.color = Color("#5d96cc")
		2: 
			nodo.color = Color("#cc5d87")

func randomLevel(num, palette = null): # crea un numxnum num = [4]
									# palette = [RED,WHITE,YELLOW]
	
	var randgrid = []
	
	
	
	for i in pow(num,2): # de momento es completamente aleatorio sin reglas
		
		if Main.colorGame: # si hay colores en juego # hay que establecer normas para que todos los colores salgan al menos una vez
			randgrid.append([randi_range(0,1),palette[randi_range(0,len(palette))]])
		else:
			randgrid.append([randi_range(0,1),Color.BLACK])
	
	return randgrid

func phys_contador(delta,reloj,minutos): # un contador por delta está atado a las físicas
	#print(reloj)
	if reloj["segundos"] >= minutos-1: # cuando el tempo llega a (60)
		
		reloj["minutos"] += 1
		reloj["segundos"] = 0
		tempo = 0

	if reloj["minutos"] == minutos-1: # cuando alcance los minutos máximos (60), se convierte en horas
		reloj["minutos"] = 0
		reloj["horas"] += 1
		tempo = 0
	
	tempo += delta
	
	if tempo >= 1.5: # simula un segundo real
		reloj["segundos"] += 1
		tempo = 0


	return reloj

func change_scene_to_file(sc):
	if get_tree().change_scene_to_file(sc) != OK:
			print ("La escena no existe")

func disable_event(interruptor):
	for i in Main.interruptores:
		if i in interruptor:
			print(i,"no permite pasar")
			return true
	return false

func dia_language(dialog_path): # cambia el idioma de un diálogo
	var raiz = "res://Dialogues/Español" # raíz por defecto
	var directorio = [""]
	var stop = false

	if Main.idioma == "es":
		raiz = "res://Dialogues/Español" 
		
	if Main.idioma == "en":
		raiz = "res://Dialogues/English"
	
	for i in dialog_path:
		
		if directorio[0] == "/Español": # siempre va a ser el español por defecto
			directorio = [""]
			stop = true
			
		if i == "/" and stop == false:

			directorio = [""]
		
		directorio[0] += i
	
	dialog_path = raiz+directorio[0]
	
	return dialog_path

func guardar_partida():
	
	var datos = {
		"escena" : get_tree().current_scene.filename,
		"master" : Master_db,
		"musica" : Music_db,
		"sonido" : Sound_db,
		"idioma" : idioma,
		#"tiempo" : reloj,
	   
	}
	
	if Main.autosave == null:
		Main.autosave = false
		var file = FileAccess.open("res://saves/save4.save", FileAccess.WRITE)
		file.store_string(datos)
	elif Main.autosave == true:
		var file = FileAccess.open("res://saves/autosave.save", FileAccess.WRITE)
		file.store_string(datos)
		Main.autosave = false
	elif Main.autosave == false:
		var file = FileAccess.open("res://saves/save"+str(ranura)+".save", FileAccess.WRITE)
		file.store_string(datos)
	
	#return datos
func cargar_partida(data):
	
	Main.grupo = data["grupo"]
	Main.tiempo = data["tiempo"]
	Main.numM = data["master"]
	Main.numS = data["sonido"]
	#Main.numAmb = data["ambiente"]
	Main.numMc = data["musica"]
	Main.idioma = data["idioma"]
	Main.inventario = data["inventario2"]
	Main.inventario_visible = data["inventario"]
	Main.interruptores = data["interruptores"]

	Main.recently_saved = true
	Main.hora = data["hora"]
	Main.tiempo2 = {"hora":0,"minutos":0}

	Main.musica_actual = data["bg_music"]

	
	TranslationServer.set_locale(Main.idioma)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), Main.numMc)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), Main.numS)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambiente"), Main.numAmb)
	
	Main.change_scene_to_file(Main.escena)
	#Main.pos_x = 0
	#Main.pos_y = 0

func save_config(): # guarda el archivo Info, de configuración y eventos de menú principal
	
	var data = {
		"language" : Main.idioma,
		"ambiente" : Main.numAmb,
		"musica" : Main.numMc,
		"sonido" : Main.numS,
		"full_screen" : ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)),
		"ends" : Main.ends, 
	}
	
	var file = FileAccess.open("res://saves/Info.save", FileAccess.WRITE)
	file.store_string(data)


	return data

#func save_data(dict): # recibe un diccionario de información para escribir un fichero
	#pass

func default_game(): # devuelve las variables a su valor por defecto en caso de nueva partida
	
	Main.day = "1"
	Main.tempo = 0
	Main.grupo = []
	Main.new_pos = [170,112]
	Main.hora = "7:00"
	Main.tiempo = {"horas":0,"minutos":0}
	Main.tiempo2 = {"hora":0,"minutos":0}
	Main.inventario = []
	Main.inventario_visible = []
	Main.interruptores = [] # Se añaden los activados
	
	Main.horas_pasadas = ["7:00"]
	Main.evento_personaje = {}
func default_config(data):
	
	Main.idioma = data["language"]
	TranslationServer.set_locale(Main.idioma)
	Main.numAmb = data["ambiente"]
	Main.numMc = data["musica"]
	Main.numS = data["sonido"]
	Main.ends = data["ends"]
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Ambiente"), Main.numAmb)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), Main.numMc)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Sound"), Main.numS)

	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (data["full_screen"]) else Window.MODE_WINDOWED
	

func ImgToMatrix(image_path): # convierte la imagen resultado en una matriz de números
	var image = Image.new()
	
	if image.load(image_path) != OK: # carga la imagen si existe
		
		print("Error al cargar la imagen.")
		
		return []
		
	var width = image.get_width()
	var height = image.get_height()
		
	var grid = []
	
	for y in range(height):
		
		var row = []
   
		for x in range(width):       
			
			var color = image.get_pixel(x, y)
		   
			if color == Color.WHITE:
				   
				row.append(0)  # Vacío
			   
			elif color == Color.RED:
				   
				row.append(1)  # Color 1
			   
			elif color == Color.GREEN:
				   
				row.append(2)  # Color 2
			   
			elif color == Color.BLUE:
				   
				row.append(3)  # Color 3
			   
			else:
				   
				row.append(-1)  # Error o color no soportado
		
		grid.append(row)
	
	return grid
	
