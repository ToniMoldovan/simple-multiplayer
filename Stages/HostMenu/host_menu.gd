extends Control

@onready var port_edit: LineEdit = %PortEdit
@onready var password_edit: LineEdit = %PasswordEdit
@onready var back_button: Button = %BackButton
@onready var host_button: Button = %HostButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	host_button.pressed.connect(_on_host_button_pressed)

func _on_back_button_pressed() -> void:
	SceneManager.go_to(SceneManager.SceneId.MAIN_MENU)

func _on_host_button_pressed() -> void:
	Net.host_port = int(port_edit.text)
	Net.room_password = password_edit.text

	var err := Net.host_game()
	if err != OK:
		push_error("Failed to host. Error code: %s" % err)
		return
	
	SceneManager.go_to(SceneManager.SceneId.L_INTRODUCTION)
