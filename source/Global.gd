extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

#info = Variavel com informações gerais do questionario, sempre sera lido ao inicializar o programa
var info 
var perguntasPos = []
var pulou = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func getInfo():
	var file = File.new()
	if not file.file_exists("Perguntas/Info.meta"):
		print("Arquivo inexistente!")
		print("Criando arquivo")
		if file.open("Perguntas/Info.meta", File.WRITE) == 0:
			print("Arquivo criado com sucesso")
			pass
		else:
			print("Erro ao criar o arquivo")
			return
		pass
	
	print("Abrindo o arquivo para leitura")
	if file.open("Perguntas/Info.meta", File.READ) != 0:
		print("Erro ao abrir o arquivo")
		return
	print("Arquivo aberto com sucesso")
	
	print(file.get_position())
	Global.info = parse_json(file.get_line())
	
	
	Global.info["perguntas"] = 0
	for _i in range(Global.info["total_perguntas"]):
		print(file.get_position())
		perguntasPos.push_back(file.get_position())
		file.get_line()
	
	for j in range(Global.info["total_perguntas"]):
		print(perguntasPos[j])
		
		
	Global.pulou = false
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
