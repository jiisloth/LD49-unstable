extends Control


export(int) var filenumber

func update_data():
    var file = Save.saves[filenumber]
    var done = len(file["times"].keys())
    var garrots = len(file["gc"])
    var fts = len(file["fts"])
    var bonus = 0
    bonus += garrots / 40.0
    bonus += fts / 70.0
    var percent = floor((done+bonus)/36.0 * 100)
    if garrots == 37:
        percent += 1
    if fts == 37:
        percent += 1
    $Label.text = "Save " + str(filenumber+1)
    $Info.text = str(percent) + "%\n" + str(done) + "/36\n" + get_time_str(Global.total_time)
    
func get_time_str(msec):
    var seconds = msec/1000.0
    var minutes = floor(seconds/60)
    return (str(minutes).pad_zeros(2) + ":" + str(seconds - minutes * 60).pad_zeros(2).pad_decimals(2))
