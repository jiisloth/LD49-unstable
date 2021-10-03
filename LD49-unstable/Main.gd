extends Node2D

export(PackedScene) var Level

var current_map

func run_map(number):
    if $Cooldown.time_left == 0:
        $Cooldown.start()
        $UI/LevelInfo.hide()
        $UI/RunInfo.hide()
        $UI/TileMap.hide()
        $Sounds/NextLevel.play()
        $UI/MapSelector.hide()
        $UI/PB.hide()
        $UI/CurrentTime.show()
        $UI/CurrentTime.text = "Loading.."
        var level = Level.instance()
        level.map = number
        current_map = level
        add_child(level)

func set_time(msec):

    $UI/CurrentTime.show()
    $UI/CurrentTime.text = get_time_str(msec)

func hide_time():
    $UI/CurrentTime.hide()
    
func show_pb():
    $UI/PB.show()
    
    
func show_end():
    Global.maps = current_map.map
    $UI/EndOfLevel.show()


func _on_BackToMenu_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            go_back_to_level_selector()
            
func go_back_to_level_selector():
    if current_map != null:
        Global.total_time += current_map.current_time
        current_map.queue_free()
    go_to_level_selector()
    
func go_to_level_selector():
    update_total()
    $Sounds/Back.play()
    $UI/MainMenu.hide()
    $UI/EndOfLevel.hide()
    $UI/CurrentTime.hide()
    $UI/LevelInfo.show()
    $UI/RunInfo.show()
    $UI/TileMap.show()
    $UI/PB.hide()
    $UI/MapSelector.show()
    $UI/MapSelector.update_cleared()


func show_text(s):
    $UI/InfoText.text = s


func _on_Restart_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            restart_level()

func restart_level():
    $Sounds/Redo.play()
    $UI/EndOfLevel.hide()
    var next_map = current_map.map
    Global.total_time += current_map.current_time
    current_map.queue_free()
    run_map(next_map)

func _on_Next_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            next_map()

func next_map():
    $UI/EndOfLevel.hide()
    var next_map = current_map.map + 1
    Global.total_time += current_map.current_time
    current_map.queue_free()
    run_map(next_map)


func get_time_str(msec):
    var seconds = msec/1000.0
    var minutes = floor(seconds/60)
    return (str(minutes).pad_zeros(2) + ":" + str(seconds - minutes * 60).pad_zeros(2))

func show_info(map):
    var time = "--:--.--"
    if map in Global.times.keys():
        time = get_time_str(Global.times[map])
    var slothtime = get_time_str(Global.sloth[map])
    $UI/LevelInfo.text = "LEVEL " + str(map) + "\n\nPB:          " + time + "\nsloth:       " + slothtime

func update_total():
    var done = Global.maps
    var percent = floor(done/36.0 * 100)
    var sob = 0
    for time in Global.times.values():
        sob += time
    $UI/RunInfo.text = str(done) + "/36   " + str(percent) + "%\nTotal:       " + get_time_str(Global.total_time) + "\nSum of Best: " + get_time_str(sob)

func _ready():
    update_total()


func _on_Timer_timeout():
    $UI/TileMap/Char.frame += 1
    $UI/MainMenu/TileMap/Char.frame += 1
    if $UI/TileMap/Char.frame == 3:
        $UI/TileMap/Char.frame = 0
        $UI/MainMenu/TileMap/Char.frame = 0


func go_to_menu():
    $UI/TileMap.hide()
    $UI/MapSelector.hide()
    $UI/LevelInfo.hide()
    $UI/RunInfo.hide()
    $UI/MainMenu.show()
    $UI/MainMenu/Play.grab_focus()
    $UI/Controls.hide()


func _process(delta):
    if $UI/Splash.visible and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        go_to_menu()
        $UI/Splash.hide()
        $Sounds/NextLevel.play()
        $Cooldown.start()
    if $UI/MainMenu/Play.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        go_to_level_selector()
        $Sounds/Blib.play()
        $Cooldown.start()

    if $UI/MainMenu/Controls.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        $Sounds/Blib.play()
        $UI/MainMenu.hide()
        $UI/Controls.show()
        $Cooldown.start()
    if $UI/Controls.visible and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        $Cooldown.start()
        $Sounds/Blib.play()
        go_to_menu()
        
        


func _on_Play_focus_entered():
    $UI/MainMenu/Play/Sprite.frame_coords.y = 1
    $Sounds/Blib.play()


func _on_Play_focus_exited():
    $UI/MainMenu/Play/Sprite.frame_coords.y = 0


func _on_Controls_focus_entered():
    $UI/MainMenu/Controls/Sprite.frame_coords.y = 1
    $Sounds/Blib.play()


func _on_Controls_focus_exited():
    $UI/MainMenu/Controls/Sprite.frame_coords.y = 0


func _on_Play_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            go_to_level_selector()
            $Sounds/Blib.play()


func _on_Controls_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            $Sounds/Blib.play()
            $UI/MainMenu.hide()
            $UI/Controls.show()


func _on_Play_mouse_entered():
    $UI/MainMenu/Play.grab_focus()


func _on_Controls_mouse_entered():
    $UI/MainMenu/Controls.grab_focus()


func _on_Controlsgui_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            $Sounds/Blib.play()
            go_to_menu()
