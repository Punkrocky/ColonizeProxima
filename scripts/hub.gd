extends Node2D

@export var PACKET:PackedScene = preload("res://scenes/resource_packet.tscn");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.
  add_child(PACKET.instantiate());


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
