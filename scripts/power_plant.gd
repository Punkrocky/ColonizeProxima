extends Building_Base

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  pass;
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  if(bIsActive):
  #{
    var CurrentMousePos = get_global_mouse_position();
    position = AlignMouseToGrid(CurrentMousePos);
    
    if(BuildingTileMap.get_cell_source_id(BuildingTileMap.local_to_map(CurrentMousePos - BuildingTileMap.position)) > -1
    || (CurrentMousePos.x < 16 || CurrentMousePos.x > 1264 || CurrentMousePos.y < 8 || CurrentMousePos.y > 704)):
    #{
      $Sprite2D.modulate = Color.RED;
    #}
    else:
    #{
      $Sprite2D.modulate = Color.GREEN;
    #}
  #}
#}
