extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var message_composer = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/Main/ComposerMargin/MessageComposer/MessageComposer/PanelContainer/ViewportContainer
onready var message_log = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/Main/MessageLogMargin/HBoxContainer/MessageLogScroll/MarginContainer/MessageLog
onready var message_log_scroll = $PanelContainer/VBoxContainer/HBoxContainer/MarginContainer/Main/MessageLogMargin/HBoxContainer/MessageLogScroll
onready var scrollbar = message_log_scroll.get_v_scrollbar()

var message_scene = preload("res://Message.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.window_fullscreen = false
	message_composer.connect("send_message", self, "message_upload")


func message_upload(img : Image):
	var tex = ImageTexture.new()
	tex.create_from_image(img)

	var new_message = message_scene.instance()
	var texture_rect : TextureRect = new_message.get_node("MarginContainer2/VBoxContainer/TextureRect")
	texture_rect.set_texture(tex)
	message_log.add_child(new_message)
	
	yield(get_tree(), "idle_frame")
	message_log_scroll.scroll_vertical = scrollbar.max_value



func _process(delta):
	if (Input.is_action_just_pressed("ui_cancel")):
		get_tree().quit()




func _on_ViewportContainer_mouse_entered():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	message_composer._cursor.visible = true

func _on_ViewportContainer_mouse_exited():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	message_composer._cursor.visible = false
