extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player

# Called when the node enters the scene tree for the first time.
func _ready():
    player = get_parent().get_node("Player")



func _process(delta):
    rotation_degrees += 0.8
    var dist = global_position.distance_to(player.global_position)
    move_and_slide((player.global_position - global_position).normalized()* 2 * (dist/2))
