extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.getInfo()
	
	#var data = file.get_as_text()
	#Global.info = parse_json(file.get_line())
	print(Global.info['tema'])
	print(Global.info['perguntas'])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_icon_clicked(_name):
	get_tree().change_scene("res://Pergunta.tscn")
	pass # Replace with function body.
