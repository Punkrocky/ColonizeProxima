extends Node2D

const MetalIcon:Texture = preload("res://assets/Metal_Icon.png");

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.
  $Sprite2D.texture = MetalIcon;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  if(!$NavigationAgent2D.is_navigation_finished()):
  #{
    global_position = global_position.move_toward(global_position + global_position.direction_to($NavigationAgent2D.get_next_path_position()) * 50 * delta, 50 * delta);
  #}
#}

func _input(event: InputEvent) -> void:
#{
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()):
    #{
      $NavigationAgent2D.target_position = get_global_mouse_position();
    #}
  #}
#}
