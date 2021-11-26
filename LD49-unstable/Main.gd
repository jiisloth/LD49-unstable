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
        $UI/Msg/PB.hide()
        $UI/Msg/FTS.hide()
        $UI/Msg/GC.hide()
        $UI/CurrentTime.show()
        $UI/CurrentTime.text = "Loading.."
        var level = Level.instance()
        level.map = number
        current_map = level
        call_deferred("add_child", current_map)
        


func set_time(msec):

    $UI/CurrentTime.show()
    $UI/CurrentTime.text = get_time_str(msec)

func hide_time():
    $UI/CurrentTime.hide()
    
func show_pb():
    $UI/Msg/PB.show()
    
    
func show_fts():
    $UI/Msg/FTS.show()
    
    
func show_gc():
    $UI/Msg/GC.show()
    
    
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
    $UI/Msg/PB.hide()
    $UI/Msg/FTS.hide()
    $UI/Msg/GC.hide()
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
    return (str(minutes).pad_zeros(2) + ":" + str(seconds - minutes * 60).pad_zeros(2).pad_decimals(2))

func show_info(map):
    var time = "--:--.--"
    map = str(map)
    if map in Global.times.keys():
        print(Global.times[map])
        time = get_time_str(Global.times[map])
    var slothtime = get_time_str(Global.sloth[map])
    $UI/LevelInfo.text = "LEVEL " + str(map) + "\n\nPB:          " + time + "\nsloth:       " + slothtime
    if map in Global.fts:
        $UI/LevelInfo/FTS.show()
    else:
        $UI/LevelInfo/FTS.hide()
    if map in Global.gc:    
        $UI/LevelInfo/GC.show()
    else:
        $UI/LevelInfo/GC.hide()
    
func update_total():
    var done = len(Global.times.keys())
    var garrots = len(Global.gc)
    var fts = len(Global.fts)
    var bonus = 0
    bonus += garrots / 40.0
    bonus += fts / 70.0
    var percent = floor((done+bonus)/36.0 * 100)
    if garrots == 37:
        percent += 1
    if fts == 37:
        percent += 1
    percent = pad(percent,7)
    var padding = ""
    for i in len(str(done)) - 2:
        padding += " "
    var sob = 0
    for time in Global.times.values():
        sob += time
    $UI/RunInfo.text = str(done) + "/36         " + padding + str(percent) + "%\nTotal:       " + get_time_str(Global.total_time) + "\nSum of Best: " + get_time_str(sob)

func pad(s, x, c=" "):
    s = str(s)
    var spaces = ""
    for i in x-len(s):
        spaces += c
    return spaces + s


func _ready():
    connect_buttons()
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

func go_to_fileselect():
    $UI/Files.show()
    $Sounds/NextLevel.play()
    $Cooldown.start()
    $UI/Files/Savefileselector1.grab_focus()
    $UI/Files/Savefileselector1.update_data()
    $UI/Files/Savefileselector2.update_data()
    $UI/Files/Savefileselector3.update_data()


func _process(delta):
    if $UI/Splash.visible and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        $UI/Splash.hide()
        go_to_fileselect()
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
        
    if $UI/Files/Savefileselector1.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        select_file(0)
    if $UI/Files/Savefileselector2.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        select_file(1)
    if $UI/Files/Savefileselector3.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        select_file(2)
      
    if $UI/Files/Delete1.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        ask_delete(0)
    if $UI/Files/Delete2.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        ask_delete(1)
    if $UI/Files/Delete3.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        ask_delete(2)
        
    if $UI/AreYouSure/Back.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        $UI/AreYouSure.hide()
        go_to_fileselect()
        
    if $UI/AreYouSure/Delete.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        Save.reset_file(Global.savefile)
        $UI/AreYouSure.hide()
        go_to_fileselect()
        
    if $UI/MainMenu/BacktoFS.has_focus() and Input.is_action_just_pressed("ui_accept") and $Cooldown.time_left == 0:
        $UI/MainMenu.hide()
        go_to_fileselect()


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




func _on_Controlsgui_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            $Sounds/Blib.play()
            go_to_menu()


func _on_Splash_gui_input(event):    
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):    
            $UI/Splash.hide()
            go_to_fileselect()
            
    
    
func connect_buttons():
    var buttons = [
        $UI/MainMenu/Play,
        $UI/MainMenu/Controls,
        $UI/MainMenu/BacktoFS,
        $UI/TileMap/Control,
        $UI/Files/Savefileselector1,
        $UI/Files/Savefileselector2,
        $UI/Files/Savefileselector3,
        $UI/Files/Delete1,
        $UI/Files/Delete2,
        $UI/Files/Delete3,
        $UI/AreYouSure/Back,
        $UI/AreYouSure/Delete
       ]
    for button in buttons:
        button.connect("focus_entered", self, "_on_button_focus_entered", [button])
        button.connect("focus_exited", self, "_on_button_focus_exited",  [button])
        button.connect("mouse_entered", self, "_on_button_mouse_entered",  [button])
    

func _on_button_focus_entered(target):
    target.get_node("Sprite").frame_coords.y = 1
    $Sounds/Blib.play()


func _on_button_focus_exited(target):
    target.get_node("Sprite").frame_coords.y = 0


func _on_button_mouse_entered(target):
    target.grab_focus()


func _on_Savefileselector1_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            select_file(0)

func _on_Savefileselector2_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            select_file(1)

func _on_Savefileselector3_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            select_file(2)


func select_file(file): 
    Save.load_file(file)
    Global.savefile = file
    $Cooldown.start()
    go_to_menu()
    $UI/Files.hide()
    $Sounds/NextLevel.play()


func _on_Delete1_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            ask_delete(0)

func _on_Delete2_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            ask_delete(1)

func _on_Delete3_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            ask_delete(2)


func ask_delete(file):
    Global.savefile = file
    $UI/AreYouSure/InfoText.text = "Are you sure you want to delete save " + str(file+1) + "?"
    $UI/AreYouSure/Back.grab_focus()
    $UI/Files.hide()
    $UI/AreYouSure.show()
    $Sounds/Blib.play()


func _on_Back_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            $UI/AreYouSure.hide()
            go_to_fileselect()


func _on_Delete_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            Save.reset_file(Global.savefile)
            $UI/AreYouSure.hide()
            go_to_fileselect()
            


func _on_BacktoFS_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            $UI/MainMenu.hide()
            go_to_fileselect()
