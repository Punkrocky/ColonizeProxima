extends Node2D

@export var PACKET:PackedScene = preload("res://scenes/resource_packet.tscn");
var InvoiceArray:Array;
var CurrentInvoice:Invoice;

var food_to_send:int;
var metal_to_send:int;
var energy_to_send:int;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.
  


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
    print("HUB recieved building placed!");
    InvoiceArray.push_back(invoice);
    print("<",invoice.FoodCost,",",invoice.MetalCost,",",invoice.EnergyCost,",",invoice.BuildingPosition,">");
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
