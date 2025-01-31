extends Node2D

@export var Enemy:PackedScene = preload("res://scenes/enemy.tscn");
@export var WaveStrength:int = 4; # Number of enemies in a wave
var CurrentCount:int = 0;
var ID = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.
  $SpawnTimer.start();


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  pass

func _on_spawned_enemie_death() -> void:
#{
  CurrentCount -= 1;
  if(CurrentCount <= WaveStrength/2):
  #{
    for i in find_children("Enemy??", "", false, false): # After the first 10, enemies will retrete at half force
    #{
      i.set_state(3);
    #}
  #}
  
#}


# Times the waves of enemies
func _on_spawn_timer_timeout() -> void:
#{
  $SpawnInterval.start();
  $SpawnTimer.start($SpawnTimer.wait_time - 1);
#}


# Spawns the enemies
func _on_spawn_interval_timeout() -> void:
#{
  CurrentCount += 1;
  ID += 1;
  var NewEnemy = Enemy.instantiate();
  NewEnemy.name = "Enemy" + str(ID);
  NewEnemy.HUBPosition = get_parent().find_child("HUB", false).global_position;
  NewEnemy.Frame = randi_range(0, 2);
  NewEnemy.get_child(1).Death.connect(_on_spawned_enemie_death);
  add_child(NewEnemy);
  
  if(CurrentCount >= WaveStrength):
  #{
    $SpawnInterval.stop();
  #}
  if(ID % 10 == 0):
  #{
    WaveStrength += 1;
  #}
#}


func _on_area_2d_body_entered(body: Node2D) -> void:
  if(body.get_parent() is CharacterBody2D):
    if(body.get_parent().CurrentState == 3):
      body.get_parent().Destination = body.global_position;
