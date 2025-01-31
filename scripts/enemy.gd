extends CharacterBody2D

enum PATH_STATE {NONE, IDLE, ATTACK, RETREATE};

@export var Damage:int = 1;
@export var Frame:int = 0;    # What type this enemy will display as [0,2]
@export var Speed:float = 50; # Magnitude of travel vector
var Destination:Vector2;      # World location to travel to
var HUBPosition:Vector2;      # World location of the HUB
var Direction:Vector2;        # Normalized vector to travel in
var Target:Area2D;            # DamageComponent of the closest building
var CurrentState:int;         # How this enemy should act

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#{
  $Sprite2D.frame = Frame;
  CurrentState = PATH_STATE.IDLE;
  $HealthComponent.get_child(0).visible = false;
  Destination = HUBPosition;
  #var RandomOffset:Vector2 = Vector2(randf(), randf()) * 16;
  #Direction = (Destination - position).normalized();
#}

func set_state(state:int) -> void:
  CurrentState = state;

func _process(delta: float) -> void:
#{
  match(CurrentState):
  #{
    PATH_STATE.IDLE:
      Destination = global_position + Vector2(randf_range(-1,1), randf_range(-1,1)) * 128;
      CurrentState = PATH_STATE.NONE;
    PATH_STATE.ATTACK:
      Destination = HUBPosition + (Vector2(randf(), randf()) * 16);
    PATH_STATE.RETREATE:
      Destination = get_parent().global_position + (Vector2(randf(), randf()) * 24);
  #}
#}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
#{
  var TravelVector:Vector2 = Destination - global_position;
  if(TravelVector.length_squared() > 2):
  #{
    Direction = TravelVector.normalized();
    #position += Direction * Speed * delta;
    #move_and_collide(Direction * Speed * delta);
    velocity = Direction * Speed;
  #}
  elif(TravelVector.length_squared() > 0.5):
  #{
    #move_and_collide(TravelVector * Speed * delta);
    velocity = TravelVector * Speed;
  #}
  else:
  #{
    Destination = global_position;
    #move_and_collide(Vector2(0,0));
    velocity = Vector2(0,0);
    
    if(CurrentState == PATH_STATE.NONE):
      CurrentState = randi() % 2 + 1;
    elif(CurrentState == PATH_STATE.ATTACK && Target == null):
      CurrentState = PATH_STATE.IDLE;
    elif(CurrentState == PATH_STATE.RETREATE):
      CurrentState = PATH_STATE.ATTACK;
  #}
  move_and_slide()
#}


func _on_health_component_death() -> void:
#{
  $Sprite2D.frame += 3;
  $DamageComponent/CollisionShape2D.set_deferred("disabled", true);
  $SweepArea/CollisionShape2D.set_deferred("disabled", true);
  $CollisionShape2D.set_deferred("disabled", true);
  var parent = get_parent();
  name = name + "Dead";
  print(name, " Death  Parent: " , parent);
#}


func _on_damage_component_damaged(x: int) -> void:
#{
  var damageDirection:Vector2 = $DamageComponent.LastDamageDirection;
  $GPUParticles2D.process_material.direction = Vector3(damageDirection.x,damageDirection.y,0);
  $GPUParticles2D.emitting = true;
  set_physics_process(false);
  $HealthComponent.take_damage(x);
#}


func _on_sweep_area_area_entered(area: Area2D) -> void:
#{
  var areaParent = area.get_parent();
  if(areaParent is Building_Base):
  #{
    if(areaParent.bIsConstructionDone):
    #{
      Destination = areaParent.global_position;
      
    #}
  #}
#}


func _on_attack_cooldown_timeout() -> void:
#{
  if(Target):
    Target.deal_damage(Damage);
#}


func _on_damage_component_area_entered(area: Area2D) -> void:
#{
  if(area is DamageComponent && area.get_parent() is Building_Base && area.get_parent().bIsConstructionDone):
  #{
    Target = area;
    if(!Target.get_parent().building_destroyed.is_connected(_on_building_destroyed)):
      Target.get_parent().building_destroyed.connect(_on_building_destroyed);
    $AttackCooldown.start();
  #}
#}


func _on_damage_component_area_exited(area: Area2D) -> void:
#{
  pass # Replace with function body.
  Target = null;
  #Destination = HUBPosition;
#}


func _on_building_destroyed() -> void:
#{
  $AttackCooldown.stop();
  Destination = HUBPosition;
  Target = null;
#}
