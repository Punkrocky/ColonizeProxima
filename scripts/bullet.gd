extends Node2D

@export var Damage:int = 1;
@export var Speed:float = 400;
@export var Angle:float;
var Direction:Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  Direction = Vector2(1,0);
  Direction = Direction.rotated(Angle);
  $Timer.start();
#}


func _physics_process(delta: float) -> void:
  position += Direction * Speed * delta;


func _on_timer_timeout() -> void:
#{
  queue_free();
#}

func _on_area_2d_area_entered(area: Area2D) -> void:
#{
  if(area is DamageComponent):
  #{
    area.LastDamageDirection = Direction;
    area.deal_damage(Damage);
    #$Area2D/CollisionShape2D.set_deferred("disabled", true);
    $Area2D.set_collision_mask_value(2, false);
    queue_free();
  #}
#}
