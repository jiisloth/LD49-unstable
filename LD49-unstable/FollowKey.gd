extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var player
var flap = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    player = get_parent().get_node("Player")
    print(name)


func _process(delta):
    rotation_degrees += 0.8
    flap += 1
    var dist = global_position.distance_to(player.global_position)
    move_and_slide((player.global_position - global_position).normalized()* 2 * (dist/2))
    $WingL.rotation_degrees = -rotation_degrees + rad2deg(cos(flap/10.0))/2 
    $WingR.rotation_degrees = -rotation_degrees - rad2deg(cos(flap/10.0))/2 +180
    if flap < 30:
        $shadow.modulate.a = 1 - flap/30.0
        $shadow.scale = Vector2.ONE * (3 + flap/2.0)
    if flap > 30:
        $shadow.hide()
