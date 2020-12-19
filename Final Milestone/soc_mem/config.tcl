# User config
set ::env(DESIGN_NAME) openstriVe_soc_mem

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "clk"

#newly added
set ::env(RUN_MAGIC) 1
set ::env(FP_CORE_UTIL) 25
set ::env(FP_ASPECT_RATIO) 1
set ::env(PL_TARGET_DENSITY) 0.35
set ::env(SYNTH_READ_BLACKBOX_LIB) 1
set ::env(DIODE_INSERTION_STRATEGY) 3
set ::env(SYNTH_STRATEGY) 1
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 2
set ::env(DESIGN_IS_CORE) 0

set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]
set ::env(SYNTH_USE_PG_PINS_DEFINES) "USE_POWER_PINS"

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

