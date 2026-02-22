extends Node

const DEFAULT_PORT: int = 7777

var host_port: int = DEFAULT_PORT

var join_ip: String = "127.0.0.1"
var join_port: int = DEFAULT_PORT
var room_password: String = ""

var max_clients: int = 2
var peer: ENetMultiplayerPeer

func _ready() -> void:
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)

func host_game() -> Error:
	# Clean up any previous session.
	stop()

	peer = ENetMultiplayerPeer.new()

	# Official flow: create_server then assign to MultiplayerAPI.multiplayer_peer.
	var err := peer.create_server(host_port, max_clients)
	if err != OK:
		peer = null
		return err

	multiplayer.multiplayer_peer = peer
	print("Hosting on port %d" % host_port)
	return OK

func stop() -> void:
	if multiplayer.multiplayer_peer != null:
		multiplayer.multiplayer_peer = null
	peer = null

func join_game() -> Error:
	stop()
	peer = ENetMultiplayerPeer.new()
	var err := peer.create_client(join_ip, join_port)
	if err != OK:
		peer = null
		return err
	multiplayer.multiplayer_peer = peer
	print("Joining %s:%d" % [join_ip, join_port])
	return OK

# --- Signals (for now, just print) ---
func _on_connected_to_server() -> void:
	print("Connected to server.")

func _on_connection_failed() -> void:
	print("Connection failed.")

func _on_server_disconnected() -> void:
	print("Disconnected from server.")

func _on_peer_connected(id: int) -> void:
	print("Peer connected: %d" % id)

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected: %d" % id)
