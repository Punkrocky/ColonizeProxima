extends Node2D

@export var FoodResources:int = 25;
@export var MetalResources:int = 25;
@export var EnergyResources:int = 25;
@export var AmmoResources:int = 10;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/FoodLabel.text = str(FoodResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/MetalLabel.text = str(MetalResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/EnergyLabel.text = str(EnergyResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/AmmoLabel.text = str(AmmoResources);
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass
  

func consume_resource(type:int, amount:int) -> void:
#{
  match(type):
  #{
    Enums.ResourceIconType.FOOD:
    #{
      FoodResources -= amount;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/FoodLabel.text = str(FoodResources);
    #}
    Enums.ResourceIconType.METAL:
    #{
      MetalResources -= amount;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/MetalLabel.text = str(MetalResources);
    #}
    Enums.ResourceIconType.ENERGY:
    #{
      EnergyResources -= amount;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/EnergyLabel.text = str(EnergyResources);
    #}
    Enums.ResourceIconType.AMMO:
    #{
      AmmoResources -= amount;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/AmmoLabel.text = str(AmmoResources);
    #}
  #}
#}


func _on_building_produced_resource(type:int) -> void:
#{
  match(type):
  #{
    Enums.ResourceIconType.FOOD:
    #{
      FoodResources += 1;
      print("Produced Food ", FoodResources);
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/FoodLabel.text = str(FoodResources);
    #}
    Enums.ResourceIconType.METAL:
    #{
      MetalResources += 1;
      print("Produced Metal ", MetalResources);
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/MetalLabel.text = str(MetalResources);
    #}
    Enums.ResourceIconType.ENERGY:
    #{
      EnergyResources += 1;
      print("Produced Energy ", EnergyResources);
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/EnergyLabel.text = str(EnergyResources);
    #}
    Enums.ResourceIconType.AMMO:
    #{
      AmmoResources += 1;
      print("Produced Ammo ", AmmoResources);
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/AmmoLabel.text = str(AmmoResources);
    #}
  #}
#}
