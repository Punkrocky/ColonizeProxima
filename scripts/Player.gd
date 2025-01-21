extends Node2D

#@export var PlayerShader:Material = preload("res://shaders/new_shader_material.tres");

@export var RoadTileMap:Node2D;
@export var bIsActive:bool = false;
@export var CurrentZoom:Vector2 = Vector2(1,1);
@export var Speed:float; # Magnitude of travel vector
var Destination:Vector2; # World location to travel to
var Direction:Vector2;   # Normalized vector to travel in
var DestinationArray:PackedVector2Array;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  $Line2D.add_point(Vector2(0,0));
  $Line2D.add_point(Vector2(0,0));
  Destination = position; # Init the destination so the player does not move automatically
  RoadTileMap = RoadTileMap as TileMapLayer;
  pass;
  #$Sprite2D.material.set_shader_parameter("ActiveColor", Vector4(1/0.29,1/0.54,1/0.11,1.0));
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  var TravelVector:Vector2 = Destination - position;
  if(((TravelVector).length_squared() > 0.5 || !DestinationArray.is_empty()) && Speed > 0):
  #{
    if(TravelVector.length_squared() > 2):
    #{
      Direction = TravelVector.normalized();
    #}
    else: # Attempt to stop overshoot jitter by allowing smaller than unit lenght vectors to modify speed.
    #{
      if(DestinationArray.is_empty()):
      #{
        Destination = position;
        Direction = Vector2(0,0);
      #}
      else:
      #{
        Destination = DestinationArray[0];
        DestinationArray.remove_at(0);
        $Line2D.remove_point(2);
        TravelVector = Destination - position;
        Direction = TravelVector.normalized();
        #return; # End travel for this frame, allows proper recalculation of travel vector
      #}
      print(Direction);
    #}
    
    # Keep line points at the same world position by undoing any parent movements
    $Line2D.set_point_position(1, TravelVector);
    for i in range(2, $Line2D.get_point_count()):
      $Line2D.points[i] -= Direction * Speed * delta;
    
    position += Direction * Speed * delta;
  #}
  if(RoadTileMap.get_cell_source_id(RoadTileMap.local_to_map(position - RoadTileMap.position)) > -1):
    Speed = 250;
  else:
    Speed = 100;
#}

func _input(event: InputEvent) -> void:
#{
  #$Sprite2D.material.set_shader_parameter("MousePos", get_global_mouse_position()*CurrentZoom);
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && bIsActive):
    #{
      bIsActive = false;
      $SelectorSprite.visible = false;
    #}
    
    if(event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && bIsActive):
    #{
      # Restrict movement to grid aligned points, makes it easier to fallow roads
      var GridAlignedMousePos:Vector2 = ((get_global_mouse_position() + Vector2(0,8)) / 32); # Tiles are 32x32 pixels
      GridAlignedMousePos.x = roundi(GridAlignedMousePos.x); # Convert the world pos to a tile coord
      GridAlignedMousePos.y = roundi(GridAlignedMousePos.y);
      GridAlignedMousePos *= 32; # Tiles are 32x32 pixels, Convert it back to a world pos, now aligned to tiles
      GridAlignedMousePos += Vector2(0,-8); # TileMap is vertically offset by 8 pixels
      
      # Bound player to TileMap X[16+16, 1264-16] and Y[16+8, 704-8]
      #                         X[32, 1248]           Y[24, 696]
      var BoundDestination = Vector2(max(32, min(1248, GridAlignedMousePos.x)), max(24, min(696, GridAlignedMousePos.y)));
      if(event is InputEventWithModifiers && event.shift_pressed):
      #{
        DestinationArray.push_back(BoundDestination);
        $Line2D.add_point(BoundDestination-position);
        print(DestinationArray);
        return;
      #}
      if(!DestinationArray.is_empty()):
      #{
        DestinationArray.clear();
        $Line2D.clear_points();
        $Line2D.add_point(Vector2(0,0));
        $Line2D.add_point(BoundDestination-position);
        print("Clear Array");
      #}
      Destination = BoundDestination;
      $Line2D.set_point_position(1, BoundDestination-position);
    #}
  #}
  elif(event is InputEventKey):
  #{
    if(event.keycode == KEY_G && event.is_pressed()):
      print("GO!!!!");
      Speed = 100;
  #}
#}



func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#{
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()):
    #{
      bIsActive = true;
      $SelectorSprite.visible = true;
      print("Pressed!");
    #}
  #}
#}
