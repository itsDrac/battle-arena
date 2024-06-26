@tool
extends ActionLeaf


@export_enum("axe", "dual", "hands") var stance: String


func tick(actor: Node, blackboard: Blackboard) -> int:
    var barbarian: Character = actor.owner
    barbarian.skin.update_stance(stance)
    blackboard.set_value("skill_name", stance)
    return SUCCESS
