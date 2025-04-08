extends Control

# Este código crea los paneles y las soluciones
# 


var stopInteraction = false

var pictures = "res://Graphics/Pictures"
var m_player = [] # matriz que rellena el jugador



@onready var camera = get_parent().get_parent().get_node("Camera2D")
@onready var tablero = get_parent().get_parent()

var itemperrow = sqrt(Main.boardSize) # para Sistema 1, cuadrado
										  # con sqrt(Main.boardSize)

@onready var root = get_node("/root").get_children()[2] # raíz de la escena (Control)


var Size = 20 # 
var Scale = Vector2(1,1) # escala normal del botón
var border = 2 # 2 píxeles de borde en todos lados, por defecto
var objSize = Vector2(20,20) # tamaño en píxeles del botón
var objSizeBorder = Vector2(objSize.x+border,objSize.y+border)

#Hay que conseguir que panel juego deje de depender de nivel

#@onready var grid = nivel.levels[nivel.lvl]
#@onready var boardSize = len(grid) # 8
#var boardSize = null

	


func _ready() -> void:
	
	#var a = get_tree()
	#if root.name == "Nivel":
		#Main.mode = "Juego"
	
	match Main.mode:
		"Constructor":
			pass
		"Juego":
			pass

	
	#print(boardSize)
	#print(totalP)

func _process(_delta: float) -> void:
	
	pass
	#objSize = resize()
	
	
#func get_boardSize(): # lectura de lista de dos niveles
	#
	#var c = 0
	#
	#for x in levels[lvl]:
		#
		#
		#
		#for y in x:
			#
			#c += 1
	#
	#return c
	
func restartScene(): # borra la lista anterior # se llama al presionar el botón de siguiente nivel
	
	Main.totalP = 0
	
	if len(self.get_children()) != 0: # Guías
		
		for i in tablero.get_node("Guías").get_children():

			i.queue_free() # los elimina
	if len(self.get_children()) != 0: # Botones
		
		for i in self.get_children():

			i.queue_free() # los elimina
	
func createButtons(nroot : Node = self.root): # Crear la cuadrícula de botones # Parámetro opcional del nodo que llame a la función
	
	
	var count = Vector2(0,0) #contador
	var grid = root.grid # 
	var Sep = Vector2(0,0)
	
	#var grid_size = Vector2(itemperrow, itemperrow) * objSize  # Tamaño del grid en píxeles
	#var start_pos = Vector2(get_parent().size.x / 2 - grid_size.x / 2, get_parent().size.y / 2 - grid_size.y / 2)  # Centrado
	#var butpos = Vector2(0,0)

	#restartScene()

	itemperrow = sqrt(Main.boardSize)
	# self.columns = itemperrow # para GridContainer
	
	for i in (Main.boardSize): # se crea botón por cada ranura de grid
						 # el grid siempre será cuadrado
		
		
		var but = load("res://TSCN/UI/Botón.tscn").instantiate()
		var butNormS = StyleBoxFlat.new()
		
		
		butNormS.set_border_width_all(border) # 2 px por defecto
		
		self.add_child(but)
		
		
		
		
		#resize(but)
		
		objSizeBorder = rescale(but)
		
		
		#Sep.x = but.size.x * but.scale.x # tamaño en píxeles
		#Sep.y = but.size.y * but.scale.y
		
		
		
		#but.get_node("Cross").rect_scale = but.size

		
		if Main.colorGame:
			
			butNormS.bg_color = grid[i][1] # determina el color que se verá al presionar un panel
			
		if get_node("/root/").has_node("Nivel"): # activa la interacción con los paneles de juego
			
			but.connect("mouse_entered",root._on_hover.bind(but)) # "nombre señal", nombre función, bind(botón)
			but.connect("mouse_exited",root._on_exit.bind(but))
			but.connect("pressed",root._on_pressed.bind(but)) #
		
		but.position.x += Sep.x
		but.position.y += Sep.y
		
		if count.x == itemperrow-1: # cada vez que toque cambiar de fila
			
			count.x = 0
			count.y += 1
			Sep.y += objSizeBorder.y
			Sep.x = 0
			
			#butpos.x = 0
			
		else:
			
			
			Sep.x += objSizeBorder.x
			count.x += 1 # siguiente item

		#print(objSize)
	
		#but.position = Vector2((160-(Bsep.x*itemperrow))+Bsep.x,40+Bsep.y)
			# 160 - (20 * 3) = 100 -> en el caso de 3x3. Centra automáticamente
		
		
		if Main.mode != "Constructor": # parche para el modo constructor
		
			if grid[i][0] == 1: # si la clave es 1 # [{}]
			
				Main.totalP += 1
	
	
	#print(Bsep)
func createGuides():
	
	#var itemperrow = int(sqrt(Main.boardSize))
	var grid = root.grid  # Suponiendo que "grid" es una lista bidimensional con [respuesta, color]
	
	
	for axis  in ["x","y"]:
		
		for i in range(itemperrow):
			
			var chain = 0
			var guides = []
			var last_guide = null
		
			for j in range(itemperrow):
   
				var index = i * itemperrow + j if axis == "x" else j * itemperrow + i
				var is_correct = grid[index][0] == 1 # si tiene un resultado correcto
				
				if is_correct:
						chain += 1
						  
				elif chain > 0: # si no es correcto y lleva cadena, esta se rompe
					
					last_guide = new_Guide(i, j, axis, chain, last_guide) # i=row , j=col
					#last_guide = new_Guide(i, j, axis, chain, last_guide)
					#guides.append(last_guide)
					guides.append(last_guide)
					chain = 0
			
			if chain > 0: # si la fila/columna termina con cadena
				last_guide = new_Guide(i, itemperrow - 1, axis, chain, last_guide)
				guides.append(last_guide)
				chain = 0
				
			#guides.reverse() # las guías se revierten; si [1],2,3 -> 3,2,1
			
			for idx in range(len(guides)): # por cada guía que se ha creado
				
				
				guides[idx].get_node("Label").text = str(guides[idx].get_meta("chain_value"))
			
	
func new_Guide(row, col, axis, chain, last_guide):
	
	var guide = load("res://TSCN/UI/Guía.tscn").instantiate()
	var Sep = 0 # separación px por guía
	get_parent().get_parent().get_node("Guías").add_child(guide)
	
	#resize(guide)
	objSizeBorder = rescale(guide)
	
	
	
	var ref = get_reference_node(row, col, axis) # 1,1,x
	
	#guide.global_position = ref.global_position
	
	if last_guide == null:
		
		guide.global_position = ref.global_position
		
		if axis == "x":

			guide.position.x -= objSizeBorder.x*(col+1)+Sep
		if axis == "y":
			
			guide.position.y -= objSizeBorder.y*(col+1)+Sep
			#print("r", row, "c",col)
			#guide.position.y -= objSizeBorder*(row+1)+Sep
			#print(guide.position.y, guide.name,row)
		
		last_guide = guide
		
	else: # si hay una referencia de last_guide, empuja solo una posición
		
		guide.global_position = last_guide.global_position
	
		
		if axis == "x":
			guide.position.x -= objSizeBorder.x+Sep
		if axis == "y":
			guide.position.y -= objSizeBorder.y+Sep
	
	#if axis == "y":
		#guide.global_position.y = reference_node.global_position.y - col
	#guide.global_position = reference_node.global_position + Vector2(-objSizeBorder, 0) if axis == "x" else Vector2(0, -objSizeBorder)

	#guide.set_meta("chain_value", chain)  # Almacena el valor como metadato 
	last_guide.set_meta("chain_value", chain)  # Almacena el valor como metadato 
	
	return last_guide

func get_reference_node(row, col, axis):
	
	#var itemperrow = int(sqrt(Main.boardSize))
	var index = row * itemperrow + col if axis == "x" else col * itemperrow + row
	return self.get_children()[index]  # Devuelve el botón de referencia

#func new_Guide(infoP,item,lastGuide,dir,gPerRow,d): # gperRow = [[ch,xy],[ch,xy]]
	#
	#print("Nueva Guía")
	#
	#var ref = self.get_children()[item-infoP[1]] # item-i # señala el principio de la fila
										## cómo puedo pillar la referencia
	#var pan = load("res://TSCN/UI/Guía.tscn").instantiate() # hacia la izquierda
	#
	#
	#if not tablero.has_node("Guías"): # si no tiene guías
		#
		#tablero.get_node("Guías").add_child(pan)
	#
#
	#get_parent().get_parent().get_node("Guías").add_child(pan)
	#pan.get_node("Label").text = str(infoP[0])
		#
	#if lastGuide == null:
		#
		#pan.global_position = ref.global_position
		#
	#else:
#
		#
		#pan.global_position = lastGuide.global_position
	#
	#
	#resize(pan)
	#
	#if dir == "x":
	#
		#pan.global_position.x -= objSizeBorder
	#if dir == "y":
		#
		#pan.global_position.y -= objSizeBorder
	#
		#
	##gPerRow[chain] = pan # {0:pan}
	##chain = 0
	#
	#lastGuide = pan
	#
	#return [chain,lastGuide]
#func new_Guide(item,i,dir,chain,Sep,lastGuide,gPerRow):
	#
	#print("Nueva Guía")
	#
	#var ref = self.get_children()[item-i] # señala el principio de la fila
	#var pan = load("res://TSCN/UI/Guía.tscn").instantiate() # hacia la izquierda
	#
	#
	#get_parent().get_parent().get_node("Guías").add_child(pan)
	#
	#if not tablero.has_node("Guías"): # si no tiene guías
		#
		#tablero.get_node("Guías").add_child(pan)
	#
	#
		#
	#if lastGuide == null:
		#
		#pan.global_position = ref.global_position
		#
	#else:
#
		#
		#pan.global_position = lastGuide.global_position
	#
	#
	#resize(pan)
	#
	#if dir == "x":
	#
		#pan.global_position.x -= objSizeBorder
	#if dir == "y":
		#
		#pan.global_position.y -= objSizeBorder
	#
		#
	#gPerRow[chain] = pan # {0:pan}
	#chain = 0
	#
	#lastGuide = pan
	#
	#return [chain,lastGuide,gPerRow]

#func guide_Correction(item,chain,i,dir,Sep,lastGuide,gPerRow): # i -> iteración = x o y 
								## calcula dónde estarán las guías # devuelve chain
	#
	#var info = null
	#
	#if root.grid[item][0] == 1: # Si esconde un panel correcto # [[0,Color.WHITE]]
		#chain += 1
		#
	#elif chain > 0: #or i == itemperrow-1: # si 4x4 = 0123 -> 4-1 #que al menos haya encontrado un panel correcto
			#
		#
		#gPerRow.append([chain,i]) # chain, objeto de la fila (x o y)
		#
		##info = new_Guide(item,i,dir,chain,Sep,lastGuide,gPerRow) # siempre devuelve chain = 0
		##chain = info[0]
		##lastGuide = info[1]
		##gPerRow = info[2]
	#
	#if i == itemperrow-1: # si se ha acabado la línea, fuerza un chain = 0
#
		#
		#if chain >= 1: # si ha acabado con algún chain
			#
			##info = new_Guide(item,i,dir,chain,Sep,lastGuide,gPerRow)
			##chain = info[0]
			##lastGuide = info[1]
			#gPerRow.append([chain,i])
		#
		##total.append(chain) #antes de vaciar el chain, guarda una muestra
		#chain = 0
		#lastGuide = null
	#
	#
	#return [chain,lastGuide,gPerRow] #

func rescale(obj):
	
	var factor = Vector2(0,20) # parche para centrar el grid en x e y
	
	match int(Main.boardSize)	:
		
		9:
			factor.x = 9
			Scale = Vector2(1,1)
		16:
			factor.x = 9
			factor.y = 20
		25:
			factor.x = 6
		36:
			factor.x = 4
			factor.y = 15
			Scale = Vector2(0.9,0.9)
		49:
			factor.x = 6
			factor.y = 15
			Scale = Vector2(0.7,0.7)
		64: # 8x8
			factor.x = 10
			factor.y = 10
			Scale = Vector2(0.7,0.7)
			
		81: # 9x9
			factor.x = 6
			factor.y = 10
			Scale = Vector2(0.6,0.6)
			
		100:
			factor.x = 5
			factor.y = 10
			border = 1
			Scale = Vector2(0.5,0.5)
			
			#but.position -= but.size
		_:
			pass
			
	
	
	obj.scale = Scale
	var scaled_size = Vector2(obj.size.x * obj.scale.x,obj.size.y * obj.scale.y)
	var screen_size = get_viewport_rect().size  # Tamaño de la pantalla # 320,160
	var grid_size = objSize * Vector2(itemperrow, itemperrow)  # Tamaño total del grid # 60,60
	#var border_offset = border * (itemperrow - 1)  # Considera los bordes entre botones
	
	#print(obj,obj.size,obj.scale)
	objSize = scaled_size # tamaño en píxeles
	objSizeBorder.x = objSize.x+border
	objSizeBorder.y = objSize.x+border
	
	
	
	self.global_position = ((screen_size - grid_size) / 2) + factor  # Centrar el grid en la pantalla
	
	if obj != null: # si se ha pasado un objeto
		
		#obj.custom_minimum_size.x = objSize.x # en un grid container el minimum redimensiona directamente
		#obj.custom_minimum_size.y = objSize.y 
	
		#obj.size = objSize # 
		obj.scale = Scale
	
	return objSizeBorder
	
#func resize(obj):
	#
	#var factor = Vector2(0,20) # parche para centrar el grid en x e y
	#
	#match int(Main.boardSize)	:
		#
		#9:
			#objSize = Vector2(20,20)
			#factor.x = 9
		#16:
			#factor.x = 9
			#factor.y = 20
		#25:
			#factor.x = 6
		#36:
			#objSize = Vector2(16,16)
			#factor.x = 4
			#factor.y = 15
		#49:
			#objSize = Vector2(14,14)
			#factor.x = 6
			#factor.y = 15
		#64: # 8x8
			#objSize = Vector2(14,14)
			#factor.x = 10
			#factor.y = 10
			#
		#81: # 9x9
			#objSize = Vector2(11,11)
			#factor.x = 6
			#factor.y = 10
			#
			#
		#100:
			#objSize = Vector2(10,10)
			#factor.x = 5
			#factor.y = 10
			#border = 1
			#
			##but.position -= but.size
		#_:
			#objSize = Vector2(20,20)
			#
	#
	#objSizeBorder = objSize.x+border
	#
	#var screen_size = get_viewport_rect().size  # Tamaño de la pantalla # 320,160
	#var grid_size = objSize * Vector2(itemperrow, itemperrow)  # Tamaño total del grid # 60,60
	##var border_offset = border * (itemperrow - 1)  # Considera los bordes entre botones
	#
	#self.global_position = ((screen_size - grid_size) / 2) + factor  # Centrar el grid en la pantalla
	#
	#if obj != null: # si se ha pasado un objeto
		#
		#obj.custom_minimum_size.x = objSize.x # en un grid container el minimum redimensiona directamente
		#obj.custom_minimum_size.y = objSize.y 
	#
		#obj.size = objSize # 
