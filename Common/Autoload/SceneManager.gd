#SceneManager.gd
extends Node

enum SceneId {
	MAIN_MENU,
	HOST_GAME,
	JOIN_GAME,
	L_INTRODUCTION
}

const SCENES = {
	SceneId.MAIN_MENU: "res://Stages/MainMenu/main_menu.tscn",
	SceneId.HOST_GAME: "res://Stages/HostMenu/host_menu.tscn",
	SceneId.JOIN_GAME: "res://Stages/JoinMenu/join_menu.tscn",
	SceneId.L_INTRODUCTION: "res://Stages/LIntroduction/game.tscn"
}

func go_to(id: int) -> void:
	var path = SCENES.get(id)
	if path == "":
		push_error("SceneManager: Unknown scene id: %s" %id)
		return
	
	var err = get_tree().change_scene_to_file(path)
	if err:
		push_error("SceneManager: Failed to change scene to %s (err=%s)" % [path, err])
