extends Area2D

var selectRequestingNodes = []
var mayDragNodes = []

func zoomIfTop(node):
	selectRequestingNodes.append(node)

func setMayDragIfTop(node):
	mayDragNodes.append(node)
	

func _physics_process(delta):
	var overlapping_bodies = get_overlapping_bodies()
	if overlapping_bodies != []:
		if selectRequestingNodes.size() > 0:
			for selectRequestingNode in selectRequestingNodes:
				for body in overlapping_bodies:
					if body.is_in_group("card"):
						if body.holderLayer > selectRequestingNode.holderLayer:
							selectRequestingNodes.erase(selectRequestingNode)
							return
				selectRequestingNode.makeZoom()
				selectRequestingNodes = []
				continue
	
		if mayDragNodes.size() > 0:
			for mayDragNode in mayDragNodes:
				for body in overlapping_bodies:
					if body.is_in_group("card"):
						if body.holderLayer > mayDragNode.holderLayer:
							mayDragNodes.erase(mayDragNode)
							return
				if mayDragNodes.size() > 0:
					mayDragNode.mayDrag = true
					mayDragNodes = []
					continue
