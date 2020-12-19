
# Design
# User config
set ::env(DESIGN_NAME) ibex_core

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "clk_i"

#added after init
set ::env(RUN_MAGIC) 1
set ::env(FP_CORE_UTIL) 35
set ::env(FP_ASPECT_RATIO) 1
set ::env(PL_TARGET_DENSITY) 0.4
set ::env(SYNTH_READ_BLACKBOX_LIB) 1

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}


# Regression
set ::env(FP_CORE_UTIL) 45
set ::env(PL_TARGET_DENSITY) 0.5
set ::env(SYNTH_STRATEGY) 3
set ::env(FP_ASPECT_RATIO) 1
set ::env(SYNTH_MAX_FANOUT) 5

# Extra
#set ::env(STD_CELL_LIBRARY) sky130_fd_sc_hd
