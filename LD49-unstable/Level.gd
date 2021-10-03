extends Node2D

export(PackedScene) var Unstable
export(PackedScene) var Key
export(PackedScene) var Goal
export(PackedScene) var Garot
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var has_garot = false
var map = 1
var tilemap
var win = false
var start_time = 0
var lvlready = false
var current_time = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    Global.stopped = []
    get_tilemap()
    generate_floor()
    generate_unstable()
    $Player/Camera2D.current = true
    $Timer.start()
    
    
func get_tilemap():
    var mappath = "res://Maps/Map_" + str(map).pad_zeros(2) + ".tscn"
    print(mappath)
    tilemap = load(mappath)
    tilemap = tilemap.instance()
    add_child(tilemap)
    get_parent().hide_time()
    
func generate_floor():
    for x in range(-500,100):
        $Floor.set_cell(x, 0, 0)
    
func generate_unstable():
    var tiles = tilemap.get_used_cells()
    for tile in tiles:
        var pos = Vector2(tile.x, tile.y) * 16 * 3 + Vector2.ONE*8*3 + Vector2(0,17)  
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
            6:
                var garot = Garot.instance()
                garot.position = pos
                add_child(garot)
                tilemap.set_cell(tile.x, tile.y, -1)
        
func garot_get():
    $Garrot.play()
    if win:
        garot_collected()
    has_garot = true

func garot_collected():
    if not map in Global.gc:
        Global.gc.append(map)
        get_parent().show_gc()

           
func end_level():
    get_node("/root/Main").show_text("")
    $Player.win = true
    win = true
    if has_garot:
        garot_collected()
    current_time = OS.get_ticks_msec() - start_time
    get_parent().set_time(current_time)
    if map in Global.times.keys():
        if Global.times[map] > current_time:
            Global.times[map] = current_time
            get_parent().show_pb()
            $Pb.play()
        else:      
            $Win.play()
    else:
        Global.times[map] = current_time
        $Win.play()
    if current_time < Global.sloth[map]:
        get_parent().show_fts()
        if not map in Global.fts:
            Global.fts.append(map)
        
    get_parent().show_end()
        

func _process(delta):
    if not win and map != 38 and start_time != 0:
        current_time = OS.get_ticks_msec() - start_time
        get_parent().set_time(current_time)
    if Input.is_action_just_pressed("back_to_menu"):
        get_node("/root/Main").show_text("")
        get_parent().go_back_to_level_selector()
    if Input.is_action_just_pressed("restart"):
        get_node("/root/Main").show_text("")
        get_parent().restart_level()
    if Input.is_action_just_pressed("next_map") and win:
        get_node("/root/Main").show_text("")
        get_parent().next_map()
    
    if (Input.is_action_just_pressed("left") or Input.is_action_just_pressed("right") or Input.is_action_just_pressed("jump") or Input.is_action_just_pressed("next_map")) and lvlready and start_time == 0:
        start_level()


func start_level():     
    start_time = OS.get_ticks_msec()
    $Player.linear_velocity = Vector2.ZERO
    for obj in Global.stopped:
        obj.linear_velocity = Vector2.ZERO
        obj.mode = RigidBody2D.MODE_RIGID
    $Player.mode = RigidBody2D.MODE_CHARACTER
    Global.stopped = []
    get_node("/root/Main").show_text("")


func _on_Timer_timeout():
    if map != 38:
        get_node("/root/Main").show_text(("LEVEL " + str(map) + "\nMove to start the level!"))
        lvlready = true
    else:
        start_level()
