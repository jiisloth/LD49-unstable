extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const jumpv = Vector2(0,-400)
const maxspeed = 300
var win = false
var on_ground = false
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
    applied_force = applied_force/2
    $Leg.physics_material_override.bounce = 0
    
    var move = Input.get_action_strength("right")-Input.get_action_strength("left")
    if win:
        move = 0
    $Leg.angular_velocity = move*40
    if (linear_velocity.x < 0 and move < 0) or (linear_velocity.x > 0 and move > 0):
        if abs(linear_velocity.x) < maxspeed:
            add_central_force(Vector2(move*500,0))
    else:       
        add_central_force(Vector2(move*500,0))
    rotation_degrees = move*20

    
    on_ground = false
    for raycast in $Casts.get_children():
        var collider = raycast.get_collider()
        if collider:
            on_ground = true
    if on_ground:
        pass
    else: 
        linear_velocity.y += 20
        
    if Input.is_action_just_pressed("jump") and not win:
        var objects = {}
        var jump = false
        for raycast in $Casts.get_children():
            var collider = raycast.get_collider()
            if collider:
                jump = true
                var cname = collider.name
                if len(cname.split("@")) == 2:
                    cname = cname.split("@")[0]
                if cname == "Unstable":
                    var collider_id = collider.get_instance_id()
                    var point = raycast.get_collision_point()
                    var distance = raycast.global_position - point
                    if collider_id in objects.keys():
                        if objects[collider_id]["distance"] > distance:
                            objects[collider_id]["distance"] = distance
                            objects[collider_id]["point"] = point
                    else:
                        objects[collider_id] = {}
                        objects[collider_id]["distance"] = distance
                        objects[collider_id]["point"] = point
        if jump:
            for oid in objects.keys():
                var object = instance_from_id(oid)
                object.apply_impulse(object.global_position - objects[oid]["point"], jumpv.rotated(deg2rad(move*30+180)))
            apply_central_impulse(2.5*jumpv)#.rotated(deg2rad(move*30)))


func _process(delta):
    if Input.get_action_strength("right")-Input.get_action_strength("left") < 0:
        $Sprite.scale.x = -3
    elif Input.get_action_strength("right")-Input.get_action_strength("left") > 0:
        $Sprite.scale.x = 3
    if on_ground:
        if win:
            $AnimationPlayer.play("win")
        else:
            if abs(Input.get_action_strength("right")-Input.get_action_strength("left")) > 0:
                $AnimationPlayer.play("running")
            else:
                $AnimationPlayer.play("standing")
    else:
        if linear_velocity.y > 0:
            $AnimationPlayer.play("falling")
        else:
            $AnimationPlayer.play("jumping")
            
            
