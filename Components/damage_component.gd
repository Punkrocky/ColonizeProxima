extends Area2D
class_name DamageComponent

signal Damaged(x:int)

var LastDamageDirection:Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func deal_damage(damage:int):
  Damaged.emit(damage);
