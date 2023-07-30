extends MultiplayerSynchronizer


signal on_basic_attack(pressed: bool)
signal on_secondary_attack(pressed: bool)
signal on_block(pressed: bool)
signal on_third_attack(pressed: bool)
signal on_dodge(pressed: bool)
signal on_ultimate(pressed: bool)
signal on_cancel()


@export var input_source: InputSource:
    set(value):
        input_source = value
        input_source.init(owner)

@export var move_direction: Vector2
@export var look_at_point: Vector3


func _ready() -> void:
    set_process(is_multiplayer_authority())


func _process(delta: float) -> void:
    move_direction = input_source.get_move_direction()
    look_at_point = input_source.get_look_at_point()
    
    _process_actions("basic_attack")
    _process_actions("secondary_attack")
    _process_actions("third_attack")
    _process_actions("block")
    _process_actions("dodge")
    
    if input_source.is_cancel_just_pressed(): on_cancel.emit()


func _process_actions(action: String) -> void:
    if multiplayer.is_server():
        _process_actions_locally(action)
        return
    
    if input_source.call("is_%s_just_pressed" % action):
        _on_action_triggered.rpc_id(1, "on_%s" % action, true)
    elif input_source.call("is_%s_just_released" % action):
        _on_action_triggered.rpc_id(1, "on_%s" % action, false)


func _process_actions_locally(action: String) -> void:
    if input_source.call("is_%s_just_pressed" % action):
        _on_action_triggered("on_%s" % action, true)
    elif input_source.call("is_%s_just_released" % action):
        _on_action_triggered("on_%s" % action, false)


# TODO: Fix local mode
@rpc("reliable", "call_remote")
func _on_action_triggered(signal_name: String, pressed: bool) -> void:
    emit_signal(signal_name, pressed)

