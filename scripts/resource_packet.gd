extends Node2D
class_name ResourcePacket;

const FoodIcon:Texture = preload("res://assets/Food_Icon.png");
const MetalIcon:Texture = preload("res://assets/Metal_Icon.png");
const EnergyIcon:Texture = preload("res://assets/Energy_Icon.png");

@export var Icon := Enums.ResourceIconType.NONE;
@export var Target:Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  match (Icon):
  #{
    Enums.ResourceIconType.FOOD:
      $Sprite2D.texture = FoodIcon;
    Enums.ResourceIconType.METAL:
      $Sprite2D.texture = MetalIcon;
    Enums.ResourceIconType.ENERGY:
      $Sprite2D.texture = EnergyIcon;
  #}
  $NavigationAgent2D.target_position = Target;
#}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  if(!$NavigationAgent2D.is_navigation_finished()):
  #{
    var MoveSpeed = 100 * delta;
    global_position = global_position.move_toward(global_position + global_position.direction_to($NavigationAgent2D.get_next_path_position()) * MoveSpeed, MoveSpeed);
  #}
#}

func _input(event: InputEvent) -> void:
#{
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()):
    #{
      pass
      #$NavigationAgent2D.target_position = get_global_mouse_position();
    #}
  #}
#}
