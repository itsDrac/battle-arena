## Handles triggering sequence of skills. Works only with 'pressed' state
extends Node


var _skills: Array
var _current_skill_number: int
var _skill_scheduled: bool


var current_skill:
    get: return _skills[_current_skill_number]
var cooldown: Timer:
    get: return current_skill.cooldown
var execution: Timer:
    get: return current_skill.execution


func _ready() -> void:
    for child in get_children():
        var skill = child
        _skills.append(skill)


func activate(pressed: bool) -> void:
    _skill_scheduled = pressed
    var is_fully_reset: = _current_skill_number == 0 and execution.is_stopped() and cooldown.is_stopped()
    if pressed and is_fully_reset: _trigger_skill_sequence()


func cancel() -> void:
    if execution.is_stopped(): return
    _skill_scheduled = false
    _current_skill_number = 0
    current_skill.cancel()


func _trigger_skill_sequence() -> void:
    while _skill_scheduled:
        if not current_skill.cooldown.is_stopped():
            await current_skill.cooldown.timeout

        current_skill.activate(true)

        if not current_skill.execution.is_stopped():
            await current_skill.execution.timeout

        _current_skill_number = (_current_skill_number + 1) % _skills.size()
    _current_skill_number = 0
