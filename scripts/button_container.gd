extends PanelContainer


const BUILDING_POWERPLANT:PackedScene = preload("res://scenes/power_plant.tscn");


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass


func _on_power_plant_button_pressed() -> void:
#{
  print("Power Plant!");
  var NewPowerPlant = BUILDING_POWERPLANT.instantiate();
  NewPowerPlant.BuildingTileMap = $"../../Building_TileMapLayer";
  $"../..".add_child(NewPowerPlant);
#}
