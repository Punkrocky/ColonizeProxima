extends PanelContainer



const BUILDING_FARM:PackedScene = preload("res://scenes/farm.tscn");
const BUILDING_MINE:PackedScene = preload("res://scenes/mine.tscn");
const BUILDING_POWERPLANT:PackedScene = preload("res://scenes/power_plant.tscn");
const BUILDING_FACTORY:PackedScene = preload("res://scenes/factory.tscn");
const BUILDING_GUN_TURRET:PackedScene = preload("res://scenes/gun_turret.tscn");

var bHasPickedBuilding:bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_building_placed() -> void:
  bHasPickedBuilding = false;

func _on_farm_button_pressed() -> void:
#{
  bHasPickedBuilding = true;
  var NewFarm = BUILDING_FARM.instantiate();
  NewFarm.bIsActive = true;
  NewFarm.GroundTileMap = $"../../Ground_TileMapLayer";
  NewFarm.BuildingTileMap = $"../../Building_TileMapLayer";
  NewFarm.RoadsTileMap = $"../../Road_TileMapLayer";
  NewFarm.building_placed.connect($"../../HUB"._on_building_placed);
  NewFarm.produced_resource.connect($"../.."._on_building_produced_resource);
  NewFarm.Cost = Invoice.new(0,2,1);
  $"../..".add_child(NewFarm);
#}

func _on_mine_button_pressed() -> void:
#{
  bHasPickedBuilding = true;
  var NewMine = BUILDING_MINE.instantiate();
  NewMine.bIsActive = true;
  NewMine.GroundTileMap = $"../../Ground_TileMapLayer";
  NewMine.BuildingTileMap = $"../../Building_TileMapLayer";
  NewMine.RoadsTileMap = $"../../Road_TileMapLayer";
  NewMine.building_placed.connect($"../../HUB"._on_building_placed);
  NewMine.produced_resource.connect($"../.."._on_building_produced_resource);
  NewMine.Cost = Invoice.new(2,0,1);
  $"../..".add_child(NewMine);
#}

func _on_power_plant_button_pressed() -> void:
#{
  bHasPickedBuilding = true;
  var NewPowerPlant = BUILDING_POWERPLANT.instantiate();
  NewPowerPlant.bIsActive = true;
  NewPowerPlant.GroundTileMap = $"../../Ground_TileMapLayer";
  NewPowerPlant.BuildingTileMap = $"../../Building_TileMapLayer";
  NewPowerPlant.RoadsTileMap = $"../../Road_TileMapLayer";
  NewPowerPlant.building_placed.connect($"../../HUB"._on_building_placed);
  NewPowerPlant.produced_resource.connect($"../.."._on_building_produced_resource);
  NewPowerPlant.Cost = Invoice.new(1,2,0);
  $"../..".add_child(NewPowerPlant);
#}


func _on_factory_button_pressed() -> void:
#{
  bHasPickedBuilding = true;
  var NewFactory = BUILDING_FACTORY.instantiate();
  NewFactory.bIsActive = true;
  NewFactory.GroundTileMap = $"../../Ground_TileMapLayer";
  NewFactory.BuildingTileMap = $"../../Building_TileMapLayer";
  NewFactory.RoadsTileMap = $"../../Road_TileMapLayer";
  NewFactory.building_placed.connect($"../../HUB"._on_building_placed);
  NewFactory.produced_resource.connect($"../.."._on_building_produced_resource);
  NewFactory.Cost = Invoice.new(1,2,4);
  $"../..".add_child(NewFactory);
#}


func _on_gun_turret_button_pressed() -> void:
#{
  bHasPickedBuilding = true;
  var NewGunTurret = BUILDING_GUN_TURRET.instantiate();
  NewGunTurret.bIsActive = true;
  NewGunTurret.GroundTileMap = $"../../Ground_TileMapLayer";
  NewGunTurret.BuildingTileMap = $"../../Building_TileMapLayer";
  NewGunTurret.RoadsTileMap = $"../../Road_TileMapLayer";
  NewGunTurret.building_placed.connect($"../../HUB"._on_building_placed);
  NewGunTurret.produced_resource.connect($"../.."._on_building_produced_resource);
  NewGunTurret.Cost = Invoice.new(0,1,0);
  $"../..".add_child(NewGunTurret);
#}
