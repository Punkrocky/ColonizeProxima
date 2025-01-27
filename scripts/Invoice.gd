extends Resource
class_name Invoice;

@export var FoodCost:int;
@export var MetalCost:int;
@export var EnergyCost:int;
@export var BuildingPosition:Vector2;

func _init(food:int = 0, metal:int = 0, energy:int = 0, building_position:Vector2 = Vector2(0,0)) -> void:
#{
  FoodCost = food;
  MetalCost = metal;
  EnergyCost = energy;
  BuildingPosition = building_position;
#}
