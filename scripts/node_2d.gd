extends Building_Base



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
    || GroundTileMap.get_cell_atlas_coords(TileCoord) != Vector2i(2,0) # Metal ground tiles
    || (CurrentMousePos.x < 16 || CurrentMousePos.x > 1264 || CurrentMousePos.y < 8 || CurrentMousePos.y > 712)
    || !(func(x): for i in x: if(RoadsTileMap.get_cell_source_id(i) > -1): return true)
        .call(RoadsTileMap.get_surrounding_cells(TileCoord))
      ):
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
      BuildingTileMap.set_cell(BuildingTileMap.local_to_map(position - BuildingTileMap.position), 1, Vector2i(2,0));
      finished_construction.emit();
      $ProductionTimer.start();
    #}
  #}
#}


func _on_production_timer_timeout() -> void:
#{
  produced_resource.emit(Enums.ResourceIconType.METAL);
  $GPUParticles2D.emitting = true;
#}


func _on_health_component_death() -> void:
#{
  $Sprite2D.frame = 1;
  $HealthComponent.visible = false;
  $DamagedSprite.visible = false;
  $Area2D/CollisionShape2D.set_deferred("disabled", true);
  $DamageComponent/CollisionShape2D.set_deferred("disabled", true);
  $ProductionTimer.stop();
  var TileMapCoord:Vector2i = BuildingTileMap.local_to_map(position - BuildingTileMap.position);
  BuildingTileMap.set_cell(TileMapCoord, 0, Vector2i(2,0));
  GroundTileMap.set_cell(TileMapCoord, 0, Vector2i(0,0));
  #(func(x): for i in x: GroundTileMap.set_cell(i, 0, Vector2i(0,0))).call(RoadsTileMap.get_surrounding_cells(TileMapCoord));
  set_process(false);
#}


func _on_damage_component_damaged(x: int) -> void:
  $HealthComponent.take_damage(x);
