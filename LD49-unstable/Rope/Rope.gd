extends Node2D


export(PackedScene) var RopePhys
export(PackedScene) var Link
export(PackedScene) var RopePart


var loops = 10
var target
var type

func _ready():
    var physparent = $Anchor
    var drawparent = target
    for i in range (loops):
        var child = addLoop(physparent, i)
        var drawchild = addDrawLoop(drawparent, child)
        addLink(physparent, child)
        physparent = child
        drawparent = drawchild
        
func addLoop(parent,i):
    var loop = RopePhys.instance()
    loop.position = parent.position
    loop.position.y += 1
    loop.linear_damp = i
    add_child(loop)
    return loop
    
func addDrawLoop(parent, phys):
    var loop = RopePart.instance()
    loop.phys = phys
    loop.type = type
    #loop.position = parent.position
    parent.add_child(loop)
    return loop.get_node("End")
    
func addLink(parent, child):
    var pin = Link.instance()
    pin.node_a = parent.get_path()
    pin.node_b = child.get_path()
    parent.add_child(pin)
    
func _physics_process(delta):
    global_position.y += 0.8*((target.global_position.y)-global_position.y)
    global_position.x += 0.1*((target.global_position.x)-global_position.x)
