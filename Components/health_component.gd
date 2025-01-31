extends Node2D
class_name HealthComponent

signal Death;

@export var Health:int;
var MAX_HEALTH:int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  MAX_HEALTH = Health;
  $Panel.size.x = 4 + Health * 4 + (Health - 1) * 2;
  for i in Health:
  #{
    var healthPip = ColorRect.new();
    healthPip.color = Color.GREEN;
    healthPip.custom_minimum_size = Vector2(4, 0);
    $Panel/Margin/HBox.add_child(healthPip);
  #}
  visible = false;
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func take_damage(damage:int) -> void:
#{
  visible = true;
  Health -= damage;
  if(Health <= 0):
  #{
    Death.emit();
    return;
  #}
  $Panel/Margin/HBox.get_child(Health).visible = false;
  
  if(Health < MAX_HEALTH):
  #{
    var sprite = get_parent().find_child("DamagedSprite");
    if(sprite):
      sprite.visible = true;
  #}
#}
