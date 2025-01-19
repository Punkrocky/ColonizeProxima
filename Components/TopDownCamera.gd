class_name TopDownCamera
extends Camera2D

var LastMousePos:Vector2;
var DeltaPos:Vector2;
var bRightMouseButton:bool;
var bLeftMouseButton:bool;
var bDragCamera:bool;

func minv(a:Vector2, b:float) -> Vector2:
#{
  var temp:float = minf(a.x, b);
  return Vector2(temp, temp);
#}

func maxv(a:Vector2, b:float) -> Vector2:
#{
  var temp:float = maxf(a.x, b);
  return Vector2(temp, temp);
#}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  pass
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  pass
#}

func _input(event:InputEvent) -> void:
#{
  if(event is InputEventMouse):
  #{
    var CameraPosition:Vector2 = position;
    var MousePosition:Vector2 = get_global_mouse_position();
    
    #print(zoom);
    var MouseVector:Vector2 = (MousePosition - CameraPosition) * ((zoom+Vector2(1,1)) / 10);
    #print(MouseVector);
    
    if(event is InputEventMouseButton):
    #{
      if event.button_index == MOUSE_BUTTON_RIGHT:
      #{
        if event.is_pressed():
        #{
          bRightMouseButton = true;
        #}
        else:
        #{
          bRightMouseButton = false;
          bDragCamera = false;
        #}
      #}
      elif event.button_index == MOUSE_BUTTON_LEFT:
      #{
        if event.is_pressed():
        #{
          bLeftMouseButton = true;
        #}
        else:
        #{
          bLeftMouseButton = false;
        #}
      #}
      elif(event.button_index == MOUSE_BUTTON_WHEEL_UP):
      #{
        zoom = minv(zoom * 1.075, 4.0);
        #if(zoom.x < 2.99):
        ##{
          #position += MouseVector;
        ##}
      #}
      elif(event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
      #{
        zoom = maxv(zoom * 0.925, 0.5);
        #if(zoom.x > 0.21):
        ##{
          #position -= MouseVector;
        ##}
      #}
    #}
    $"../Player".CurrentZoom = zoom;
    # When the mouse is moving across the screen
    if (event is InputEventMouseMotion and bRightMouseButton):
    #{
      DeltaPos = event.position - LastMousePos;
      position += (-DeltaPos / zoom);
      bDragCamera = true;
      
      #Keep camera bound to the play area, allows the player to have any tile at the center of the screen
      if(position.x < 0 || position.x > 1280):
      #{
        position.x -= (-DeltaPos.x / zoom.x); #Undo the last operation
      #}
      if(position.y < 0 || position.y > 720):
      #{
        position.y -= (-DeltaPos.y / zoom.y);
      #}
    #}
    
    LastMousePos = event.position;
  #}
  return;
#}
