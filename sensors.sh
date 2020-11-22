#!/usr/bin/sh

OUTPUT_DIR=/tmp/livestream-tools-4544eeb7

mkdir -p $OUTPUT_DIR/

watch -tc -pn 1 "
	# mem
	livestream-meminfo $OUTPUT_DIR/mem_used.txt $OUTPUT_DIR/swap_used.txt 2>&1

	# CPU
	livestream-sensor-conv /sys/class/hwmon/hwmon1/temp1_input $OUTPUT_DIR/cpu_tctl.txt 2>&1
	livestream-sensor-conv /sys/class/hwmon/hwmon1/temp2_input $OUTPUT_DIR/cpu_tdie.txt 2>&1

	# GPU
	livestream-sensor-conv /sys/class/hwmon/hwmon3/temp1_input $OUTPUT_DIR/gpu_edge.txt 2>&1
	livestream-sensor-conv /sys/class/hwmon/hwmon3/temp2_input $OUTPUT_DIR/gpu_junction.txt 2>&1
	livestream-sensor-conv /sys/class/hwmon/hwmon3/temp3_input $OUTPUT_DIR/gpu_mem.txt 2>&1

	# SSD
	livestream-sensor-conv /sys/class/hwmon/hwmon0/temp1_input $OUTPUT_DIR/ssd_composite.txt 2>&1
"
