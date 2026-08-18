extends RayCast2D

#does not remove target node again so when checking for a new object will not take previous not into acount anymore
func HasLineOfSight(TargetNode : Node) -> bool:
	
	if !TargetNode:
		return false
	
	add_exception(TargetNode)
	target_position = to_local(TargetNode.position)
	
	var res = true
	if is_colliding():
		res = false
	
	return res
