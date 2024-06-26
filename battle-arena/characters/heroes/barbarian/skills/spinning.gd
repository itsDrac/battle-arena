extends "res://characters/skills/chanelling_skill.gd"


@export var spinning_modifier: PackedScene
@export var damage: float
@export_range(0.01, 2, 0.01) var time_between_hits: float
@export var radius: float = 2


var _tween: Tween


func _on_activate(pressed: bool) -> void:
    if execution.is_stopped():
        var modifier: TimedModifier = spinning_modifier.instantiate()
        modifier.time = execution.base_time
        owner.modifiers.add_modifier(modifier)
        
        if multiplayer.is_server():
            _tween = create_tween().set_loops((int)(execution.wait_time / time_between_hits))
            _tween.tween_callback(_try_hit_area).set_delay(time_between_hits)

    # this will trigger finish function if already in progress
    super._on_activate(pressed)


func _on_finish() -> void:
    if _tween: _tween.kill()
    super._on_finish()
    owner.modifiers.remove_modifier_by_name("Spinning")


func _try_hit_area() -> void:
    if execution.is_stopped(): return
    
    var space_state: PhysicsDirectSpaceState3D = owner.get_world_3d().direct_space_state

    var shape_rid = PhysicsServer3D.sphere_shape_create()
    PhysicsServer3D.shape_set_data(shape_rid, radius)
    
    var params = PhysicsShapeQueryParameters3D.new()
    params.shape_rid = shape_rid
    params.collide_with_bodies = false
    params.collide_with_areas = true
    params.collision_mask = collision_mask
    params.transform = owner.transform
    
    var result: = space_state.intersect_shape(params)
    
    for hit in result:
        if hit.collider is HitBox:
            hit.collider.on_damage.emit(damage)
    
    PhysicsServer3D.free_rid(shape_rid)
