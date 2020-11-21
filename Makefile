INSTALL_DIR := ~/.local/bin
SCRIPT_PREFIX := livestream-

install:
	mkdir -p $(INSTALL_DIR)
	cp -f meminfo.sh $(INSTALL_DIR)/$(SCRIPT_PREFIX)meminfo
	cp -f sensor-conv.sh $(INSTALL_DIR)/$(SCRIPT_PREFIX)sensor-conv
	cp -f sensors.sh $(INSTALL_DIR)/$(SCRIPT_PREFIX)sensors
	cp -f start.sh $(INSTALL_DIR)/$(SCRIPT_PREFIX)start
.PHONY: install
