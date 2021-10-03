extends RigidBody2D


var sprite = Vector2(0,0)

const weight_scale = 14
const atributes = [
    [
        {"weight": 0.8, "special": false},
        {"weight": 1, "special": false},
        {"weight": 1.6, "special": false},
        {"weight": 2, "special": false}
       ],
    [
        {"weight": 1.8, "special": false},
        {"weight": 0.6, "special": false},
        {"weight": 0.3, "special": false},
        {"weight": 1, "special": false}
       ],
    [
        {"weight": 0.9, "special": false},
        {"weight": 1, "special": "passtrough"},
        {"weight": 0.9, "special": "ice"},
        {"weight": 1, "special": "float"}
       ]
   ]

# Called when the node enters the scene tree for the first time.
func _ready():
    $Tile.frame_coords = sprite
    weight = atributes[sprite.y][sprite.x]["weight"] * weight_scale
    match atributes[sprite.y][sprite.x]["special"]:
        "passtrough":
            set_collision_layer_bit(0, false)
            set_collision_layer_bit(1, false)
            set_collision_mask_bit(0, false)
            set_collision_mask_bit(1, false)
        "ice":
            var physics_material = PhysicsMaterial.new()
            physics_material.friction = 0.05
            physics_material.rough = false
            physics_material_override = physics_material
        "float":
            gravity_scale = -1
            
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
