@tool
extends BeehaveTree


var execution: float:
    get: return blackboard.get_value("execution", 0.0, self.root_node.name)

var cooldown: float:
    get: return blackboard.get_value("cooldown", 0.0, self.root_node.name )

var title: String:
    get: return tr(self.root_node.name)

var description: String:
    get: return tr("%s_desc" % self.root_node.name)

var root_node: BeehaveNode:
    get:
        var running_action: BeehaveNode = blackboard.get_value("running_action", null, str(actor.get_instance_id()))
        if not running_action: return get_child(0)
        return running_action.get_parent()
