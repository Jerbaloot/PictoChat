extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_position = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	update()

func _input(event):
	if event is InputEventMouseMotion:
		mouse_position = event.position


func _draw():
	draw_line(Vector2.ZERO, mouse_position-global_position, Color.red)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
