extends Node2D

# Scenes
const PLAYER_SCENE = preload("res://Entities/Player/player.tscn")

@onready var peer_label: Label = %PeerLabel
@onready var chat_edit: LineEdit = $CanvasLayer/ChatEdit
@onready var players: Node = %Players
@onready var player_spawner: MultiplayerSpawner = $MultiplayerSpawner


func _ready() -> void:
	_update_peer_label()
	
	player_spawner.spawn_function = _spawn_player_from_data
	
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

	# Host also needs its own player.
	if multiplayer.is_server():
		_spawn_player_for_peer(multiplayer.get_unique_id())

	# Update whenever something changes
	multiplayer.peer_connected.connect(func(_id: int) -> void:
		_update_peer_label()
	)
	multiplayer.peer_disconnected.connect(func(_id: int) -> void:
		_update_peer_label()
	)
	multiplayer.connected_to_server.connect(func() -> void:
		_update_peer_label()
	)
	multiplayer.server_disconnected.connect(func() -> void:
		_update_peer_label()
	)
	chat_edit.text_submitted.connect(_on_chat_send_pressed)

func _update_peer_label() -> void:
	# TODO: @ _update_peer_label(): The multiplayer instance isn't currently active.
	var my_id := multiplayer.get_unique_id()
	var peers := multiplayer.get_peers() # Array of connected peer IDs (excluding yourself)
	peer_label.text = "My ID: %s\nPeers: %s" % [str(my_id), str(peers)]

func _on_chat_send_pressed(_t: String) -> void:
	var msg := chat_edit.text.strip_edges()
	if msg.is_empty():
		return
	chat_edit.clear()

	# This calls the RPC on *all* peers (including yourself).
	rpc_chat_message.rpc(msg)

@rpc("any_peer", "reliable", "call_local")
func rpc_chat_message(msg: String) -> void:
	# If this RPC was called by a remote peer, this returns their peer ID.
	# If it was called locally (because of call_local), it will be your own ID.
	var from_id := multiplayer.get_remote_sender_id()
	if from_id == 0:
		from_id = multiplayer.get_unique_id()

	print("[CHAT] from %s -> received on %s: %s"
		% [str(from_id), str(multiplayer.get_unique_id()), msg])

func _on_peer_connected(id: int) -> void:
	if multiplayer.is_server():
		_spawn_player_for_peer(id)

func _on_peer_disconnected(id: int) -> void:
	if not multiplayer.is_server():
		return

	if players.has_node(str(id)):
		players.get_node(str(id)).queue_free()
		
func _spawn_player_for_peer(peer_id: int) -> void:
	var data := {
		"peer_id": peer_id,
		"spawn_pos": Vector2(
			randi_range(100, 600),
			randi_range(100, 400)
		)
	}

	player_spawner.spawn(data)
	
func _spawn_player_from_data(data: Dictionary) -> Node:
	var player := PLAYER_SCENE.instantiate()

	var peer_id: int = data["peer_id"]
	var spawn_pos: Vector2 = data["spawn_pos"]

	player.name = str(peer_id)
	player.position = spawn_pos

	# Set the same authority on all peers during spawn.
	player.set_multiplayer_authority(peer_id)

	return player
