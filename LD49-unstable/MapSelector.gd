extends GridContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(PackedScene) var MapButton

# Called when the node enters the scene tree for the first time.
func _ready():
    generate_buttons(36)
    update_cleared()
    
func generate_buttons(count):
    for i in count:
        var button = MapButton.instance()
        button.number = i+1
        add_child(button)
    var buttons = get_children()
    var cols = columns
    for i in len(buttons):
        if i%cols-1 >= 0:
            buttons[i].focus_neighbour_left = buttons[i-1].get_path()
        if i%cols+1 < cols:
            buttons[i].focus_neighbour_right = buttons[i+1].get_path()
        if i-cols >= 0:
            buttons[i].focus_neighbour_top = buttons[i-cols].get_path()
        if i+cols < len(buttons):
            buttons[i].focus_neighbour_bottom = buttons[i+cols].get_path()
        else:
            buttons[i].focus_neighbour_bottom = get_parent().get_node("TileMap/Control").get_path()
            get_parent().get_node("TileMap/Control").focus_neighbour_top = buttons[i].get_path()

func update_cleared():
    var buttons = get_children()
    buttons[0].grab_focus()
    for i in len(buttons):
        buttons[i].update_awards()
        if i > len(Global.times.keys()):
            buttons[i].set_frame(0)
        if i == len(Global.times.keys()):
            buttons[i].set_frame(2)
            buttons[i].grab_focus()
        if i == Global.maps +1:
            buttons[i].grab_focus()
        if i < len(Global.times.keys()):
            buttons[i].set_frame(1)
            
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("ui_accept") and get_parent().get_node("TileMap/Control").has_focus():
        get_node("/root/Main").go_to_menu()
        get_node("/root/Main/Sounds/Back").play()



func _on_Control_gui_input(event):
    if event is InputEventMouseButton:
        if (event.is_pressed() and event.button_index == BUTTON_LEFT):
            get_node("/root/Main").go_to_menu()
            get_node("/root/Main/Sounds/Back").play()
