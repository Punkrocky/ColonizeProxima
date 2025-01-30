extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.
  $HealthComponent.get_child(0).visible = false;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_health_component_death() -> void:
#{
  $Sprite2D.frame += 3;
  $DamageComponent/CollisionShape2D.set_deferred("disabled", true);
#}


func _on_damage_component_damaged(x: int) -> void:
  $HealthComponent.take_damage(x);
