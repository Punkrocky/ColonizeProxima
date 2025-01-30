extends Node2D

@export var Damage:int = 1;
@export var Speed:float = 400;
@export var Angle:float;
var Direction:Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  pass # Replace with function body.
  Direction = Vector2(1,0);
  Direction = Direction.rotated(Angle);
  $Timer.start();
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

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
    print("HIT!");
    area.deal_damage(Damage);
    queue_free();
  #}
#}
