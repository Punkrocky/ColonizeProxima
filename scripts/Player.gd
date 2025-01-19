extends Node2D

#@export var PlayerShader:Material = preload("res://shaders/new_shader_material.tres");

@export var bIsActive:bool = false;
@export var CurrentZoom:Vector2 = Vector2(1,1);

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  pass;
  #$Sprite2D.material.set_shader_parameter("ActiveColor", Vector4(1/0.29,1/0.54,1/0.11,1.0));
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  pass;
#}

func _input(event: InputEvent) -> void:
#{
  #$Sprite2D.material.set_shader_parameter("MousePos", get_global_mouse_position()*CurrentZoom);
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && bIsActive):
    #{
      bIsActive = false;
      #$Sprite2D.material.set_shader_parameter("ActiveColor", Vector4(1/0.29,1/0.54,1/0.11,1.0));
    #}
    
    if(event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed()):
    #{
      pass; #TODO: Add movement logic here later
    #}
  #}
#}



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#{
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()):
    #{
      bIsActive = true;
      #$Sprite2D.material.set_shader_parameter("ActiveColor", Vector4(0.0,0.5,0.2,1.0));
      print("Pressed!");
    #}
  #}
#}
