#join_menu.gd
extends Control

@onready var ip_edit: LineEdit = %IpEdit
@onready var port_edit: LineEdit = %PortEdit
@onready var password_edit: LineEdit = %PasswordEdit
@onready var back_button: Button = %BackButton
@onready var join_button: Button = %JoinButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)
	join_button.pressed.connect(_on_join_button_pressed)

func _on_back_button_pressed() -> void:
	SceneManager.go_to(SceneManager.SceneId.MAIN_MENU)

func _on_join_button_pressed() -> void:
	Net.join_ip = ip_edit.text.strip_edges()
	Net.join_port = int(port_edit.text)
	Net.room_password = password_edit.text

	var err := Net.join_game()
	if err != OK:
		push_error("Failed to start client. Error code: %s" % err)
		return

	SceneManager.go_to(SceneManager.SceneId.L_INTRODUCTION)
