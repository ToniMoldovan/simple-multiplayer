extends Node2D

@onready var peer_label: Label = %PeerLabel

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

func _update_peer_label() -> void:
	var my_id := multiplayer.get_unique_id()
	var peers := multiplayer.get_peers() # Array of connected peer IDs (excluding yourself)
	peer_label.text = "My ID: %s\nPeers: %s" % [str(my_id), str(peers)]
