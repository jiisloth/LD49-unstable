extends Node




const path = "user://gamedata.json"

const defaultfile = {
    "maps": 0,
    "times": {},
    "total_time": 0,
    "fts": [],
    "gc": []
   }

var saves = [
    {},
    {},
    {}
   ]

func reset_file(n):
    saves[n] = defaultfile.duplicate(true)
    
    
func init_files():
    for n in len(saves):
        reset_file(n)
        

func _ready():
    load_data()

func load_data():
    var file = File.new()
    if not file.file_exists(path):
        init_files()
    else:
        file.open(path, File.READ)
        saves = parse_json(file.get_as_text())
        file.close()
        

func save_data():
    var n = Global.savefile
    saves[n] = {
        "maps": Global.maps,
        "times": Global.times.duplicate(),
        "total_time": Global.total_time,
        "fts": Global.fts.duplicate(),
        "gc": Global.gc.duplicate()
       }
    var file = File.new()
    file.open(path, File.WRITE)
    file.store_line(to_json(saves))
    file.close()
    
func load_file(n):
    var file = saves[n]
    Global.maps = file["maps"]
    Global.times = file["times"]
    Global.total_time = file["total_time"]
    Global.fts = file["fts"]
    Global.gc = file["gc"]
    print(Global.times)
