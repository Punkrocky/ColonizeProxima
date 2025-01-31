extends Building_Base

const BULLET:PackedScene = preload("res://scenes/bullet.tscn");

var bIsPlayerSelected:bool;


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  # Draw the range of the turret using 25 points
  for i in Vector3(0.0, TAU, TAU/24.0):
    $Line2D.add_point(Vector2(200*cos(i), 200*sin(i)));
  $Line2D.add_point(Vector2(200*cos(TAU), 200*sin(TAU)));
  World = get_parent();
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  if(bIsActive):
  #{
    var CurrentMousePos = get_global_mouse_position();
    var TileCoord = BuildingTileMap.local_to_map(CurrentMousePos - BuildingTileMap.position);
    position = AlignMouseToGrid(CurrentMousePos);
    for i in $Line2D.points: # Keep the radius centered
      i += position;
    
    if(BuildingTileMap.get_cell_source_id(TileCoord) > -1
    || RoadsTileMap.get_cell_source_id(TileCoord) > -1
    || (CurrentMousePos.x < 16 || CurrentMousePos.x > 1264 || CurrentMousePos.y < 8 || CurrentMousePos.y > 712)
    || !(func(x): for i in x: if(RoadsTileMap.get_cell_source_id(i) > -1): return true)
        .call(RoadsTileMap.get_surrounding_cells(TileCoord))):
    #{
      $Sprite2D.modulate = Color.RED;
      $TopSprite.modulate = Color.RED;
    #}
    else:
    #{
      $Sprite2D.modulate = Color.GREEN;
      $TopSprite.modulate = Color.GREEN;
    #}
  #}
  else:
  #{
    if(bIsPlayerSelected):
    #{
      $Line2D.visible = true;
    #}
    else:
      $Line2D.visible = false;
  #}
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
      $TopSprite.modulate = Color.WHITE;
      # The building needs to be constructed first, set the TileMapLayer as a construction site and hide the finished Sprite
      $Sprite2D.visible = false;
      $TopSprite.visible = false;
      
      BuildingTileMap.set_cell(BuildingTileMap.local_to_map(get_global_mouse_position() - BuildingTileMap.position), 1, Vector2i(3,1));
      position = AlignMouseToGrid(get_global_mouse_position());
      Cost.BuildingPosition = position;
      building_placed.emit(Cost);
      World.consume_resource(Enums.ResourceIconType.FOOD, Cost.FoodCost);
      World.consume_resource(Enums.ResourceIconType.METAL, Cost.MetalCost);
      World.consume_resource(Enums.ResourceIconType.ENERGY, Cost.EnergyCost);
    #}
    elif(event.button_index == MOUSE_BUTTON_LEFT && event.is_pressed()
    && !bIsActive && bIsPlayerSelected && bIsConstructionDone && !Enums.bIsHoverPlayer && !World.AmmoResources <= 0):
    #{
      var NewBullet = BULLET.instantiate();
      NewBullet.Angle = get_angle_to(get_global_mouse_position());
      NewBullet.rotation = get_angle_to(get_global_mouse_position())+PI/2;
      NewBullet.position = position;
      print(get_parent().name);
      World.add_child(NewBullet);
      World.consume_resource(Enums.ResourceIconType.AMMO, 1);
    #}
    elif(event.button_index == MOUSE_BUTTON_RIGHT && event.is_pressed() && bIsActive):
    #{
      get_parent().remove_child(self);
      queue_free();
    #}
  #}
  elif(event is InputEventMouse && event is InputEventMouseMotion && bIsPlayerSelected):
  #{
    $TopSprite.rotation = (get_angle_to(get_global_mouse_position())+PI/2);
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
      $TopSprite.visible = true;
      BuildingTileMap.set_cell(BuildingTileMap.local_to_map(position - BuildingTileMap.position), 1, Vector2i(2,1));
      finished_construction.emit();
      bIsConstructionDone = true;
    #}
  #}
  elif(areaParent is Player):
  #{
    pass;
    bIsPlayerSelected = true;
    $SelectorSprite.visible = true;
  #}
#}


func _on_area_2d_area_exited(area: Area2D) -> void:
#{
  if(area.get_parent() is Player):
  #{
    bIsPlayerSelected = false;
    $SelectorSprite.visible = false;
  #}
#}

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
#{
  pass;
#}


func _on_health_component_death() -> void:
#{
  $Sprite2D.frame = 1;  building_destroyed.emit();
  
  $HealthComponent.visible = false;
  $DamagedSprite.visible = false;
  $TopSprite.visible = false;
  $Line2D.visible = false;
  $Area2D/CollisionShape2D.set_deferred("disabled", true);
  $DamageComponent/CollisionShape2D.set_deferred("disabled", true);
  
  var TileMapCoord:Vector2i = BuildingTileMap.local_to_map(position - BuildingTileMap.position);
  BuildingTileMap.set_cell(TileMapCoord, 0, Vector2i(2,1));
  GroundTileMap.set_cell(TileMapCoord, 0, Vector2i(0,0));
  (func(x): for i in x: GroundTileMap.set_cell(i, 0, Vector2i(0,0))).call(RoadsTileMap.get_surrounding_cells(TileMapCoord));
  set_process(false);
#}


func _on_damage_component_damaged(x: int) -> void:
  $HealthComponent.take_damage(x);
