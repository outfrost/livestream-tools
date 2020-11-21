#!/usr/bin/sh

# sensor_file, output_file
input=$(cat "${1}")
python3 -c "print('{:.1f}°'.format(${input} / 1000))" | tee "${2}.tmp"
mv "${2}.tmp" "${2}"
