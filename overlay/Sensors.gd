extends Node

onready var label = $Label

var file: File = File.new()

func _ready() -> void:
	$RefreshTimer.connect("timeout", self, "refresh")

func refresh() -> void:
	var top = [];
	var _r = OS.execute("top", ["-b", "-n", "1"], true, top)
	if top.empty():
		printerr("Output of `top -b -n 1` empty")
		return
	var lines = (top[0] as String).split("\n", false, 8)
	var line_cpu: int = -1
	for i in range(lines.size()):
		if (lines[i] as String).begins_with("%Cpu(s):"):
			line_cpu = i
			break
	if line_cpu < 0:
		printerr("No CPU stats in output of `top`")
		return
	var cpu_fields = (lines[line_cpu] as String).strip_escapes().split(" ", false)
	var cpu_perc = 100.0 - float(cpu_fields[7]) - float(cpu_fields[9])

	var free = [];
	var _ret = OS.execute("free", ["-k"], true, free)
	if free.empty():
		printerr("Output of `free -k` empty")
		return
	var fields = (free[0] as String).replace("\n", " ").replace("\t", " ").strip_escapes().split(" ", false)
	var used_mem_gb = float(fields[8]) / (pow(2.0, 20.0))
	var used_swap_gb = float(fields[15]) / (pow(2.0, 20.0))

	var cpu_tctl = temperature("/sys/class/hwmon/hwmon1/temp1_input")
	var cpu_tdie = temperature("/sys/class/hwmon/hwmon1/temp2_input")
	var gpu_tedge = temperature("/sys/class/hwmon/hwmon3/temp1_input")
	var gpu_tjunction = temperature("/sys/class/hwmon/hwmon3/temp2_input")
	var gpu_tmem = temperature("/sys/class/hwmon/hwmon3/temp3_input")
	var ssd_temp = temperature("/sys/class/hwmon/hwmon0/temp1_input")
	label.text = (
		"%.1f%%\n%.1f G\n%.1f G\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n"
		% [cpu_perc, used_mem_gb, used_swap_gb, cpu_tctl, cpu_tdie, gpu_tedge, gpu_tjunction, gpu_tmem, ssd_temp])

func temperature(sensor: String) -> float:
	file.open(sensor, File.READ)
	var value = float(file.get_as_text()) / 1000.0
	file.close()
	return value
