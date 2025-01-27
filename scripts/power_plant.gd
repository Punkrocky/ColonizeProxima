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
    var TileCoord = BuildingTileMap.local_to_map(CurrentMousePos - BuildingTileMap.position);
    position = AlignMouseToGrid(CurrentMousePos);
    
    if(BuildingTileMap.get_cell_source_id(TileCoord) > -1
    || RoadsTileMap.get_cell_source_id(TileCoord) > -1
    || (CurrentMousePos.x < 16 || CurrentMousePos.x > 1264 || CurrentMousePos.y < 8 || CurrentMousePos.y > 712)
    || !(func(x): for i in x: if(RoadsTileMap.get_cell_source_id(i) > -1): return true)
        .call(RoadsTileMap.get_surrounding_cells(TileCoord))):
    #{
      $Sprite2D.modulate = Color.RED;
    #}
    else:
    #{
      $Sprite2D.modulate = Color.GREEN;
    #}
  #}
#}


func _on_area_2d_area_entered(area: Area2D) -> void:
#{
  var areaParent = area.get_parent();
  if (areaParent is ResourcePacket && areaParent.Target == position):
  #{
    var type = areaParent.Icon;
    match(type):
    #{
      Enums.ResourceIconType.FOOD:
        CurrentFood += 1;
        print("Got Food ", CurrentFood);
      Enums.ResourceIconType.METAL:
        CurrentMetal += 1;
        print("Got Metal ", CurrentMetal);
      Enums.ResourceIconType.ENERGY:
        CurrentEnergy += 1;
        print("Got Energy ", CurrentEnergy);
    #}
    areaParent.queue_free();
    if(CurrentFood >= Cost.FoodCost && CurrentMetal >= Cost.MetalCost && CurrentEnergy >= Cost.EnergyCost):
    #{
      $Sprite2D.visible = true;
      BuildingTileMap.set_cell(BuildingTileMap.local_to_map(position - BuildingTileMap.position), 1, Vector2i(0,1));
      finished_construction.emit();
      $ProductionTimer.start();
    #}
  #}
#}


func _on_production_timer_timeout() -> void:
#{
  produced_resource.emit(Enums.ResourceIconType.ENERGY);
  $GPUParticles2D.emitting = true;
#}
