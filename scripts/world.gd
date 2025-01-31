extends Node2D

@export var FoodResources:int = 25;
@export var MetalResources:int = 25;
@export var EnergyResources:int = 25;
@export var AmmoResources:int = 100;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/FoodLabel.text = str(FoodResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/MetalLabel.text = str(MetalResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/EnergyLabel.text = str(EnergyResources);
  $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/AmmoLabel.text = str(AmmoResources);
  $Timer.start();
  $EnemySpawner2.get_child(0).stop();
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
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/FoodLabel.text = str(FoodResources);
    #}
    Enums.ResourceIconType.METAL:
    #{
      MetalResources += 1;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/MetalLabel.text = str(MetalResources);
    #}
    Enums.ResourceIconType.ENERGY:
    #{
      EnergyResources += 1;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/EnergyLabel.text = str(EnergyResources);
    #}
    Enums.ResourceIconType.AMMO:
    #{
      AmmoResources += 1;
      $CanvasLayer/ResourcePanel/MarginContainer/GridContainer/AmmoLabel.text = str(AmmoResources);
    #}
  #}
#}


func _on_timer_timeout() -> void:
  $Timer.stop();
  $EnemySpawner2.visible = true;
  $EnemySpawner2.get_child(0).start();


func _on_hub_building_destroyed() -> void:
  $EnemySpawner.get_child(0).stop();
  $EnemySpawner2.get_child(0).stop();
