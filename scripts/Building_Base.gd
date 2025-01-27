extends Node2D
class_name Building_Base;

signal building_placed(x:Invoice);
signal finished_construction;
signal produced_resource(x:int);

@export var GroundTileMap:TileMapLayer;
@export var BuildingTileMap:TileMapLayer;
@export var RoadsTileMap:TileMapLayer;


@export var Cost:Invoice;
var bIsActive:bool = true;
var CurrentFood:int;
var CurrentMetal:int;
var CurrentEnergy:int;

func AlignMouseToGrid(mousePos:Vector2) -> Vector2:
#{
  var GridAlignedMousePos:Vector2 = ((mousePos + Vector2(0,8)) / 32); # Tiles are 32x32 pixels
  GridAlignedMousePos.x = roundi(GridAlignedMousePos.x); # Convert the world pos to a tile coord
  GridAlignedMousePos.y = roundi(GridAlignedMousePos.y);
  GridAlignedMousePos *= 32; # Tiles are 32x32 pixels, Convert it back to a world pos, now aligned to tiles
  GridAlignedMousePos += Vector2(0,-8); # TileMap is vertically offset by 8 pixels
  return Vector2(max(32, min(1248, GridAlignedMousePos.x)), max(24, min(696, GridAlignedMousePos.y)));;
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


func _input(event: InputEvent) -> void:
#{
  if(event is InputEventMouse && event is InputEventMouseButton):
  #{
    if(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed() && bIsActive):
    #{
      if($Sprite2D.modulate == Color.RED): # Can't be placed because there is already a building here
      #{
        return; #TODO: Maybe play a sound?
      #}
      bIsActive = false;
      $Sprite2D.modulate = Color.WHITE;
      # The building needs to be constructed first, set the TileMapLayer as a construction site and hide the finished Sprite
      $Sprite2D.visible = false;
      BuildingTileMap.set_cell(BuildingTileMap.local_to_map(get_global_mouse_position() - BuildingTileMap.position), 1, Vector2i(3,1));
      position = AlignMouseToGrid(get_global_mouse_position());
      Cost.BuildingPosition = position;
      building_placed.emit(Cost);
      #TODO: Emit a signal to the HUB that a new construction site was placed
    #}
    elif(event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && bIsActive):
      get_parent().remove_child(self);
      queue_free();
  #}
#}
