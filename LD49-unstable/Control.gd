extends Control

var number = 1
var frame = 0
# Called when the node enters the scene tree for the first time.
func _ready():
    $Blib.pitch_scale += number/10.0
    $Label.text = str(number)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("ui_accept") and has_focus() and frame > 0:
        get_node("/root/Main").run_map(number)
        

func _on_Timer_timeout():
    if $Animation.frame == 3:
        $Animation.frame = frame
    else:
        $Animation.frame = 3
        

func _on_Button_focus_entered():
    grab_focus()


func _on_MapButton_focus_entered():
    if $Blib/Timer.time_left == 0:
        $Blib.play()
    $Timer.start()
    $Animation.frame = 3
    get_node("/root/Main").show_info(number)


func _on_MapButton_focus_exited():
    $Animation.frame = frame
    $Timer.stop()


func set_frame(n):
    frame = n
    $Animation.frame = frame


func _on_Button_mouse_entered():
    grab_focus()


func _on_Button_gui_input(event): 
    if event is InputEventMouseButton:# and frame > 0:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            get_node("/root/Main").run_map(number)
