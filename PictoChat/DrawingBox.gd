extends ViewportContainer

var _pen : Sprite = null
var _cursor : Sprite = null
var _prev_mouse_pos = Vector2()

var history = []
var current_index : int


signal send_message

enum TOOL_TYPES{
	ERASER,
	PENCIL,
	TEXT
}
var active_tool = TOOL_TYPES.PENCIL
var tool_input_keys = {
	TOOL_TYPES.ERASER:"eraser",
	TOOL_TYPES.PENCIL:"pencil",
	TOOL_TYPES.TEXT:"text",
}

onready var viewport : Viewport = $Viewport
onready var cursor : Sprite = $Cursor


func _ready():
	viewport.usage = Viewport.USAGE_2D
#	viewport.render_target_clear_mode = Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
#	viewport.render_target_v_flip

	_pen = Sprite.new()
	viewport.add_child(_pen)
	_pen.connect("draw", self, "_on_draw")
	
	_cursor = Sprite.new()
	_cursor.connect("draw", self, "_on_draw")
	_cursor.hide()
	add_child(_cursor)
	

func _process(delta):
	_pen.update()

	_cursor.update()

func _on_draw():
	var mouse_pos = get_local_mouse_position()
	
	if Input.is_mouse_button_pressed(BUTTON_LEFT):
		if _prev_mouse_pos != null:
			match active_tool:
				TOOL_TYPES.PENCIL:
					_pen.draw_line(mouse_pos, _prev_mouse_pos, Color(0,0,0),3)
				TOOL_TYPES.ERASER:
					_pen.draw_line(mouse_pos, _prev_mouse_pos, Color(.95,.95,.95),4)
		_prev_mouse_pos = mouse_pos
	else:
		_prev_mouse_pos = null

	match active_tool:
		TOOL_TYPES.PENCIL:
			_cursor.draw_circle(mouse_pos, 1.5, Color(0,0,0))
		TOOL_TYPES.ERASER:
			_cursor.draw_circle(mouse_pos, 2.5, Color(0,0,0))
			_cursor.draw_circle(mouse_pos, 1.5, Color(.95,.95,.95) )
	


func switch_tool(tool_type):
	active_tool = tool_type

func _input(event):
	for input_key in tool_input_keys:
		if event.is_action_pressed(tool_input_keys[input_key]):
			switch_tool(input_key)


func _on_SendMessage_pressed():
	var img = viewport.get_texture().get_data()
	img.flip_y()
	emit_signal("send_message", img)
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ALWAYS)
	$Viewport/Timer.start()
	


func _on_Timer_timeout():
	viewport.set_clear_mode(Viewport.CLEAR_MODE_ONLY_NEXT_FRAME)
