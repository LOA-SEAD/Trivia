extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal clicked(name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		
		emit_signal("clicked",$".".name)
	pass # Replace with function body.
