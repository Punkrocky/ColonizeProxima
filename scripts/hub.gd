extends Building_Base

@export var PACKET:PackedScene = preload("res://scenes/resource_packet.tscn");
var InvoiceArray:Array;
var CurrentInvoice:Invoice;

var food_to_send:int;
var metal_to_send:int;
var energy_to_send:int;

func _ready() -> void:
  World = get_parent();
  GroundTileMap = World.get_child(1);
  BuildingTileMap = World.get_child(2);
  RoadsTileMap = World.get_child(3);
  bIsConstructionDone = true;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
#{
  #TODO: Check an array of invoices for any resources that need to be sent
  if(!InvoiceArray.is_empty()): # There are buildings to build
  #{
    if(!CurrentInvoice): # We don't have a specific one selected yet
    #{
      CurrentInvoice = InvoiceArray.pop_front(); # Bug, if there is only 1 left, this will cause the list to be empty and then stop the timer
      food_to_send = CurrentInvoice.FoodCost;
      metal_to_send = CurrentInvoice.MetalCost;
      energy_to_send = CurrentInvoice.EnergyCost;
      $Timer.start();
    #}
  #}
  elif(InvoiceArray.is_empty() && !CurrentInvoice):
  #{
    # No more packets need to be spawned
    $Timer.stop();
  #}
#}

func _on_building_placed(invoice:Invoice) -> void:
  #{
    pass;
    InvoiceArray.push_back(invoice);
    #print("<",invoice.FoodCost,",",invoice.MetalCost,",",invoice.EnergyCost,",",invoice.BuildingPosition,">");
  #}


func _on_timer_timeout() -> void:
#{
  var packetIcon;
  if(food_to_send > 0):
  #{
    food_to_send -= 1;
    packetIcon = Enums.ResourceIconType.FOOD;
  #}
  elif(metal_to_send > 0):
  #{
    metal_to_send -= 1;
    packetIcon = Enums.ResourceIconType.METAL;
  #}
  elif(energy_to_send > 0):
  #{
    energy_to_send -= 1;
    packetIcon = Enums.ResourceIconType.ENERGY;
  #}
  else:
  #{
    CurrentInvoice = null;
    $Timer.stop();
    return;
  #}
  
  var packet = PACKET.instantiate();
  packet.Icon = packetIcon;
  packet.Target = CurrentInvoice.BuildingPosition;
  add_child(packet);
#}


func _on_health_component_death() -> void:
#{
  building_destroyed.emit();
  
  $Sprite2D.frame = 1;
  $HealthComponent.visible = false;
  $DamagedSprite.visible = false;
  $DamageComponent/CollisionShape2D.set_deferred("disabled", true);
  
  World.find_child("LosePanel").visible = true;
  
  var TileMapCoord:Vector2i = BuildingTileMap.local_to_map(position - BuildingTileMap.position);
  BuildingTileMap.set_cell(TileMapCoord, 0, Vector2i(0,0));
  #GroundTileMap.set_cell(TileMapCoord, 0, Vector2i(0,0));
  #(func(x): for i in x: GroundTileMap.set_cell(i, 0, Vector2i(0,0))).call(RoadsTileMap.get_surrounding_cells(TileMapCoord));
  set_process(false);
#}


func _on_damage_component_damaged(x: int) -> void:
  $HealthComponent.take_damage(x);
