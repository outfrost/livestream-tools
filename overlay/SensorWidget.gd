extends Control

enum SensorType {
	CPU_USAGE,
	MEM_USAGE,
	SWAP_USAGE,
	TEMPERATURE,
}

export(SensorType) var type
export var sensor_label: String
export var temperature_sensor_path: String

onready var value_label = $ValueLabel

var sensor_file: File = File.new()

func _ready() -> void:
	$Label.text = sensor_label
	get_parent().get_node(@"RefreshTimer").connect("timeout", self, "refresh")

func refresh() -> void:
	match type:
		SensorType.CPU_USAGE:
			value_label.text = "%.1f%%" % cpu_perc()
		SensorType.MEM_USAGE:
			value_label.text = "%.1f G" % mem_usage_gb()
		SensorType.SWAP_USAGE:
			value_label.text = "%.1f G" % swap_usage_gb()
		SensorType.TEMPERATURE:
			value_label.text = "%.1f °C" % temperature(temperature_sensor_path)

#	var cpu_tctl = temperature("/sys/class/hwmon/hwmon1/temp1_input")
#	var cpu_tdie = temperature("/sys/class/hwmon/hwmon1/temp2_input")
#	var gpu_tedge = temperature("/sys/class/hwmon/hwmon3/temp1_input")
#	var gpu_tjunction = temperature("/sys/class/hwmon/hwmon3/temp2_input")
#	var gpu_tmem = temperature("/sys/class/hwmon/hwmon3/temp3_input")
#	var ssd_temp = temperature("/sys/class/hwmon/hwmon0/temp1_input")

func cpu_perc() -> float:
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

func mem_usage_gb() -> float:
	var fields = mem_info()
	if fields.empty():
		return 0.0
	return float(fields[8]) / pow(2.0, 20.0)

func swap_usage_gb() -> float:
	var fields = mem_info()
	if fields.empty():
		return 0.0
	return float(fields[15]) / pow(2.0, 20.0)

func mem_info() -> PoolStringArray:
	var free = [];
	var _ret = OS.execute("free", ["-k"], true, free)
	if free.empty():
		printerr("Output of `free -k` empty")
		return PoolStringArray()
	return (free[0] as String).replace("\n", " ").replace("\t", " ").strip_escapes().split(" ", false)

func temperature(sensor: String) -> float:
	sensor_file.open(sensor, File.READ)
	var value = float(sensor_file.get_as_text()) / 1000.0
	sensor_file.close()
	return value
