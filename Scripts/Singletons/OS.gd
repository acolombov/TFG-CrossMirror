extends Node

# Todas las acciones de UI o Sistema operativo y controles se manejan aquí
# incluye los sistemas de guardado y configuraciones

var l = 0
var lang = OS.get_locale_language()

#var cursor_ball = load("res://Graphics/UI/Cursor.png")

func _ready():
	
	lang = OS.get_locale_language() # si el archivo Info no existe, se eligirá el idioma del sistema
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	#Input.MOUSE_MODE_HIDDEN # hace visible el cursor


func _process(_delta):
	
	#print(Input.get_mouse_mode())
	
	if Input.is_action_just_pressed("fullscreen"): # Maneja el botón de pantalla completa
		
		get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (!((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN))) else Window.MODE_WINDOWED
	

func openWindow(name,node,mode = null): #
	

	
	if !node.has_node(name): # si no existe ya permite llamarlo
		
		var win = load("res://TSCN/UI/ResponsiveWindow.tscn").instantiate()
		win.name = name
		win.get_node(name).visible = true
		node.add_child(win)
		
		
		

func changeLang(lang): #
	
	Main.idioma = lang
	TranslationServer.set_locale(Main.idioma)
	
