extends Control

@onready var host_button: Button = $CenterContainer/VBoxContainer/HostButton
@onready var join_button: Button = $CenterContainer/VBoxContainer/JoinButton
@onready var exit_button: Button = $CenterContainer/VBoxContainer/ExitButton

func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	exit_button.pressed.connect(_on_exit_pressed)
	
func _on_host_pressed() -> void:
	SceneManager.go_to(SceneManager.SceneId.HOST_GAME)
	
func _on_join_pressed() -> void:
	SceneManager.go_to(SceneManager.SceneId.JOIN_GAME)
	
func _on_exit_pressed() -> void:
	get_tree().quit()
