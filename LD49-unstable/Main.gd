extends Node2D

export(PackedScene) var Level

var current_map

func run_map(number):
    $UI/MapSelector.hide()
    $UI/PB.hide()
    $UI/CurrentTime.show()
    $UI/CurrentTime.text = "Loading.."
    var level = Level.instance()
    level.map = number
    current_map = level
    add_child(level)

func set_time(msec):
    var seconds = msec/1000.0
    var minutes = floor(seconds/60)
    #var fullseconds = floor(seconds - minutes * 60)
    #var ms = msec%1000 
    
    $UI/CurrentTime.text = str(minutes).pad_zeros(2) + ":" + str(seconds - minutes * 60).pad_zeros(2)#"" + "." + str(ms).pad_zeros(3)

func show_pb():
    $UI/PB.show()
    
    
func show_end():
    Global.maps = current_map.map
    $UI/EndOfLevel.show()


func _on_BackToMenu_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            back_to_menu()

func back_to_menu():
    $UI/EndOfLevel.hide()
    $UI/CurrentTime.hide()
    $UI/PB.hide()
    $UI/MapSelector.show()
    $UI/MapSelector.update_cleared()
    current_map.queue_free()


func _on_Restart_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            restart_level()

func restart_level():
    $UI/EndOfLevel.hide()
    var next_map = current_map.map
    current_map.queue_free()
    run_map(next_map)

func _on_Next_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            next_map()

func next_map():
    $UI/EndOfLevel.hide()
    var next_map = current_map.map + 1
    current_map.queue_free()
    run_map(next_map)
    
