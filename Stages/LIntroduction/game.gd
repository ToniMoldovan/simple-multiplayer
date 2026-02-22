extends Node2D

@onready var peer_label: Label = %PeerLabel
@onready var chat_edit: LineEdit = $CanvasLayer/ChatEdit
@onready var chat_send_button: Button = $CanvasLayer/ChatSendButton


func _ready() -> void:
	# Update immediately (in case peers already exist)
	_update_peer_label()

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
	
	chat_send_button.pressed.connect(_on_chat_send_pressed)
	chat_edit.text_submitted.connect(func(_t: String) -> void:
		_on_chat_send_pressed()
	)

func _update_peer_label() -> void:
	var my_id := multiplayer.get_unique_id()
	var peers := multiplayer.get_peers() # Array of connected peer IDs (excluding yourself)
	peer_label.text = "My ID: %s\nPeers: %s" % [str(my_id), str(peers)]

func _on_chat_send_pressed() -> void:
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
