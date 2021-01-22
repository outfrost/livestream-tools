extends Node

class MemInfo:
	var used_mem_gb: float
	var used_swap_gb: float

	func _init(mem_kb: float, swap_kb: float):
		used_mem_gb = mem_kb / pow(2.0, 20.0)
		used_swap_gb = swap_kb / pow(2.0, 20.0)

onready var label = $Label

var sensor_file: File = File.new()

func _ready() -> void:
	$RefreshTimer.connect("timeout", self, "refresh")

func refresh() -> void:
	var cpu_perc = cpu_usage()

	var mem = mem_info()

	var cpu_tctl = temperature("/sys/class/hwmon/hwmon1/temp1_input")
	var cpu_tdie = temperature("/sys/class/hwmon/hwmon1/temp2_input")
	var gpu_tedge = temperature("/sys/class/hwmon/hwmon3/temp1_input")
	var gpu_tjunction = temperature("/sys/class/hwmon/hwmon3/temp2_input")
	var gpu_tmem = temperature("/sys/class/hwmon/hwmon3/temp3_input")
	var ssd_temp = temperature("/sys/class/hwmon/hwmon0/temp1_input")

	label.text = (
		"%.1f%%\n%.1f G\n%.1f G\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n%.1f °C\n"
		% [cpu_perc, mem.used_mem_gb, mem.used_swap_gb, cpu_tctl, cpu_tdie, gpu_tedge, gpu_tjunction, gpu_tmem, ssd_temp])

func cpu_usage() -> float:
	var top = [];
	var _ret = OS.execute("top", ["-b", "-n", "1"], true, top)
	if top.empty():
		printerr("Output of `top -b -n 1` empty")
		return 0.0
	var lines = (top[0] as String).split("\n", false, 8)
	var line_cpu: int = -1
	for i in range(lines.size()):
		if (lines[i] as String).begins_with("%Cpu(s):"):
			line_cpu = i
			break
	if line_cpu < 0:
		printerr("No CPU stats in output of `top`")
		return 0.0
	var fields = (lines[line_cpu] as String).strip_escapes().split(" ", false)
	return 100.0 - float(fields[7]) - float(fields[9])

func mem_info() -> MemInfo:
	var free = [];
	var _ret = OS.execute("free", ["-k"], true, free)
	if free.empty():
		printerr("Output of `free -k` empty")
		return MemInfo.new(0.0, 0.0)
	var fields = (free[0] as String).replace("\n", " ").replace("\t", " ").strip_escapes().split(" ", false)
	return MemInfo.new(float(fields[8]), float(fields[15]))

func temperature(sensor: String) -> float:
	sensor_file.open(sensor, File.READ)
	var value = float(sensor_file.get_as_text()) / 1000.0
	sensor_file.close()
	return value
