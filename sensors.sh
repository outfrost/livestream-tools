#!/usr/bin/sh

OUTPUT_DIR=/tmp/livestream-tools-4544eeb7

mkdir -p $OUTPUT_DIR/

watch -tc -pn 1 "
	# mem
	./meminfo.sh $OUTPUT_DIR/mem_used.txt $OUTPUT_DIR/swap_used.txt 2>&1

	# CPU
	./sensor-conv.sh /sys/class/hwmon/hwmon1/temp1_input $OUTPUT_DIR/cpu_tctl.txt 2>&1
	./sensor-conv.sh /sys/class/hwmon/hwmon1/temp2_input $OUTPUT_DIR/cpu_tdie.txt 2>&1

	# GPU
	./sensor-conv.sh /sys/class/hwmon/hwmon3/temp1_input $OUTPUT_DIR/gpu_edge.txt 2>&1
	./sensor-conv.sh /sys/class/hwmon/hwmon3/temp2_input $OUTPUT_DIR/gpu_junction.txt 2>&1
	./sensor-conv.sh /sys/class/hwmon/hwmon3/temp3_input $OUTPUT_DIR/gpu_mem.txt 2>&1

	# SSD
	./sensor-conv.sh /sys/class/hwmon/hwmon0/temp1_input $OUTPUT_DIR/ssd_composite.txt 2>&1
"
