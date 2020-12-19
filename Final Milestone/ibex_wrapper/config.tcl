# User config
set ::env(DESIGN_NAME) ibex_wrapper

# Change if needed
set ::env(VERILOG_FILES) [glob $::env(DESIGN_DIR)/src/*.v]

# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "HCLK"

#added after init
set ::env(RUN_MAGIC) 1
set ::env(FP_CORE_UTIL) 25
set ::env(FP_ASPECT_RATIO) 1
set ::env(PL_TARGET_DENSITY) 0.4
set ::env(SYNTH_READ_BLACKBOX_LIB) 1
set ::env(DIODE_INSERTION_STRATEGY) 3
set ::env(SYNTH_STRATEGY) 1
set ::env(GLB_RT_MAX_DIODE_INS_ITERS) 3
set ::env(DESIGN_IS_CORE) 0

set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

