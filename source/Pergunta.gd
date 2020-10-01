extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pergunta
var respostas = []
var correct = false
var n
signal audioPlay(type)

# Called when the node enters the scene tree for the first time.
func _ready():
	correct = false
	
	
	#abre o arquivo
	var file = File.new()
	if not file.file_exists("Perguntas/Info.meta"):
		print('Arquivo inexistente/Faltando')#se mnão existir o arquivo no diretorio
		pass
	#Global.info["perguntas"]
	print("Abrindo o arquivo para leitura")
	if file.open("Perguntas/Info.meta", File.READ) != 0:
		print("Erro ao abrir o arquivo")
		return
	print("Arquivo aberto com sucesso")
	
	#le o arquivo 
	file.seek(Global.perguntasPos[Global.info["perguntas"]])
	pergunta = parse_json(file.get_line())
	#print(pergunta)
	$".".get_node("Labels").get_node("Pergunta").set_text(pergunta["pergunta"])
	$".".get_node("Labels").get_node("Pergunta_atual").set_text("Pergunta " + str(int(Global.info["total_perguntas"]) - int(Global.info["perguntas"]) + 1) + " de " + str(Global.info["total_perguntas"]))
	#intancia um objeto clicavel
	respostas = $".".get_node("Respostas").get_children()
	n = 0
	for i in pergunta["respostas"]:
		respostas[n].set_name(str(i[0]))
		respostas[n].get_node("Label").set_text(i[1])
		n += 1
	$".".get_node("Labels").get_node("Erros_restantes").set_text("Erros restantes: " + str(Global.info["limite_erros"]))
	
	if Global.pulou:
		$".".get_node("pular").visible = false
		
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#ao apertar uma das respostas
func _on_icon_clicked(name):
	print(Global.info["total_perguntas"])
	
	#se a resposta for correta
	if pergunta["respostas"][int(name)-1][2] == 1 and Global.info["limite_erros"]>0:
		correct = true
		$".".get_node("Indicador").get_node("Correto").visible = true
		emit_signal("audioPlay","Correct")
		#reduz a quantidade de perguntas restantes/ muda  a pergunta a ser carregada na proxima cena
		
	else: #se a resposta for errada
		$".".get_node("Indicador").get_node("Errado").visible = true
		emit_signal("audioPlay","Wrong")
		Global.info["limite_erros"] = Global.info["limite_erros"] -1 #reduz a quantidade de erros restantes
		respostas[int(name)-1].visible = false #deixa invisivel a resposta clicada
		#print(Global.info["limite_erros"])
		
			
	
		
	$".".get_node("Labels").get_node("Erros_restantes").set_text("Erros restantes: " + str(Global.info["limite_erros"])) #re-escreve a quantidade de erros restantes
	pass 


func _on_voltar_clicked(_name):
	get_tree().change_scene("res://Inicio.tscn")#volta ao inicio
	pass # Replace with function body.


func _on_pular_clicked(_name):
	Global.pulou = true
	Global.info["perguntas"] = Global.info["perguntas"] +1
	get_tree().change_scene("res://Pergunta.tscn")#carrega a proxima pergunta
	pass # Replace with function body.


func _on_Audio_finished():
	if correct and Global.info["limite_erros"]>0:
		$".".get_node("Indicador").get_node("Correto").visible = false
		Global.info["perguntas"] = Global.info["perguntas"] +1
		if Global.info["perguntas"]<Global.info["total_perguntas"]:#se houver ainda uma pergunta
			get_tree().change_scene("res://Pergunta.tscn")#carrega a proxima pergunta
		else:
			get_tree().change_scene("res://Fim.tscn")#se não houver mais perguntas, vai a cena do fim
	else:
		$".".get_node("Indicador").get_node("Errado").visible = false
		if not Global.info["limite_erros"]>0:#se tiver usado todos os erros
			get_tree().change_scene("res://Inicio.tscn")#volta ao inicio
	pass # Replace with function body.
