extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var win = false

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if win:
        $tiles.scale.x += 0.5
        $tiles.scale.y += 0.3
        $tiles.position.y -= 1


func _on_Goal_body_entered(body):
    var bname = body.name
    if len(bname.split("@")) == 2:
        bname = bname.split("@")[0]
    if bname == "FollowKey" or bname == "Key":
        body.queue_free()
        get_parent().end_level()
        win = true
