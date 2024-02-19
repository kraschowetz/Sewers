extends Button

@onready var layer: CanvasLayer = get_node("../..")

var vsync = {
	"off": DisplayServer.VSYNC_DISABLED,
	"on": DisplayServer.VSYNC_ENABLED,
}
var current: String = "on"

signal vsync_changed

func _on_pressed():
	if !layer.visible: return
	
	current = "on" if current == "off" else "off"
	DisplayServer.window_set_vsync_mode(vsync[current])
	text = current
	vsync_changed.emit()
