extends Node2D

export(PackedScene) var Unstable
export(PackedScene) var Key
export(PackedScene) var Goal
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var map = 1
var tilemap
var win = false
var start_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    get_tilemap()
    generate_floor()
    generate_unstable()
    $Player/Camera2D.current = true
    start_time = OS.get_ticks_msec()
    
func get_tilemap():
    var mappath = "res://Maps/Map_" + str(map).pad_zeros(2) + ".tscn"
    print(mappath)
    tilemap = load(mappath)
    tilemap = tilemap.instance()
    add_child(tilemap)
    
    
func generate_floor():
    for x in range(-500,100):
        $Floor.set_cell(x, 0, 0)
    
func generate_unstable():
    var tiles = tilemap.get_used_cells()
    for tile in tiles:
        var pos = Vector2(tile.x, tile.y) * 16 * 3 + Vector2.ONE*8*3 + Vector2(0,16)  
        if tile.y == 0:
            tilemap.set_cell(tile.x, tile.y, -1)
            $Floor.set_cell(tile.x, 0, 1)
        match tilemap.get_cell(tile.x, tile.y):
            0:
                var sprite = tilemap.get_cell_autotile_coord(tile.x, tile.y)
                var unstable = Unstable.instance()
                unstable.position = pos    
                unstable.sprite = sprite
                add_child(unstable)
                tilemap.set_cell(tile.x, tile.y, -1)
            2:
                var key = Key.instance()
                key.position = pos
                add_child(key)
                tilemap.set_cell(tile.x, tile.y, -1)
            3:
                var goal = Goal.instance()
                goal.position = pos
                add_child(goal)
                tilemap.set_cell(tile.x, tile.y, -1)
            4:
                tilemap.set_cell(tile.x, tile.y, -1)
                $Player.position = pos
            5:
                tilemap.set_cell(tile.x, tile.y, -1)
                $Floor.set_cell(tile.x, tile.y, 2)
        
            
func end_level():
    $Player.win = true
    win = true
    var current_time = OS.get_ticks_msec() - start_time
    get_parent().set_time(current_time)
    if map in Global.times.keys():
        if Global.times[map] > current_time:
            Global.times[map] = current_time
            get_parent().show_pb()
    else:
        Global.times[map] = current_time
        get_parent().show_pb()
    get_parent().show_end()
        

func _process(delta):
    if not win and map != 38:
        var current_time = OS.get_ticks_msec() - start_time
        get_parent().set_time(current_time)
    if Input.is_action_just_pressed("back_to_menu"):
        get_parent().back_to_menu()
    if Input.is_action_just_pressed("restart"):
        get_parent().restart_level()
    if Input.is_action_just_pressed("next_map") and win:
        get_parent().next_map()
