extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var phys
var type = 0

# Called when the node enters the scene tree for the first time.
func _ready():
    $Draw/ColorRect.color = [Color("#3f2832"),Color("#743f39")][type]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    $End.position = phys.position.normalized().rotated(type*PI/10)*3

    var p = global_position
    $Draw.global_position = Vector2(floor(p.x), floor(p.y))
