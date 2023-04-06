class_name Character extends CharacterBody3D


@export var speed: = 1.0
@export var attack_speed: = 1.0
@export var player_id: int:
    set(value):
        player_id = value
        $Input.set_multiplayer_authority(player_id)


@onready var animator: = $Animator
@onready var input: = $Input
@onready var spawner: = $Spawner


@onready var cup: = preload("res://characters/cup_throwable.tscn")


var is_attacking: bool:
    get: return input.is_attacking
    
    
func _ready() -> void:
    animator.active = true


func _process(_delta: float) -> void:
    var movement: Vector2 = input.movement
    velocity = Vector3(movement.x, 0.0, movement.y)
    if velocity.length_squared() > 1: velocity = velocity.normalized()
    
    animator["parameters/Movement/blend_position"] = velocity.length() * 2
    velocity *= speed
    
    move_and_slide()

    animator["parameters/Attack/speed/scale"] = attack_speed
    animator["parameters/Combo/speed/scale"] = attack_speed
    
    var look_at_point: Vector3 = input.look_at_point
    look_at(look_at_point)
    rotation_degrees.x = 0.0


func _throw() -> void:
    animator["parameters/conditions/is_throwing"] = false
    
    if not multiplayer.is_server(): return
    
    var cup_instance: Node3D = cup.instantiate()
    cup_instance.position = position
    cup_instance.set_attack_number(0)
    cup_instance.throw(input.look_at_point)
    spawner.add_child(cup_instance, true)


func _execute_secondary_attack() -> void:
    animator["parameters/conditions/is_throwing"] = true
