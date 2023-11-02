extends CharacterBody3D


signal on_dead()


@export var player_id: int


@onready var stats: StatManager = get_node_or_null("Stats")
@onready var modifiers: ModifierManager = get_node_or_null("Modifiers")
@onready var skills: SkillManager = get_node_or_null("Skills")
@onready var processors: = get_node_or_null("Processors")
@onready var skin: = get_node_or_null("Skin")
@onready var input: = get_node_or_null("Input")
@onready var hit_box: HitBox = get_node_or_null("HitBox")
@onready var hud: = get_node_or_null("HUD")


var is_alive: bool:
    get: return stats.get_stat("Health").current_value > 0.0


func _on_health_changed(old_value: float, new_value: float) -> void:
    if is_equal_approx(new_value, 0.0) or new_value < 0.0:
        on_dead.emit()


func reset() -> void:
    stats.reset()
    modifiers.reset()
    skills.reset()
