#!/usr/bin/sh

usedmem_file="${1}"
usedswap_file="${2}"

extract_info() { # free...
	python3 -c "print('{:.1f} G'.format(${9} / (2 ** 20)))" | tee "${usedmem_file}.tmp"
	python3 -c "print('{:.1f} G'.format(${16} / (2 ** 20)))" | tee "${usedswap_file}.tmp"
	mv "${usedmem_file}.tmp" "${usedmem_file}"
	mv "${usedswap_file}.tmp" "${usedswap_file}"
}

extract_info $(free -k)
