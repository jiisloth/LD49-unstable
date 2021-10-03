extends RigidBody2D

export(PackedScene) var Followkey
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass


func _on_Get_body_entered(body):
    if body.name == "Player":
        var followkey = Followkey.instance()
        followkey.global_position = global_position
        get_parent().add_child(followkey)
        queue_free()
