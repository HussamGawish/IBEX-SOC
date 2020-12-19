
lef read /pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /openLANE_flow/designs/ibex_wrapper/runs/18-12_18-19/results/routing/ibex_wrapper.def
load ibex_wrapper -dereference
cd /openLANE_flow/designs/ibex_wrapper/runs/18-12_18-19/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
extract unique
# extract warn all
extract

ext2spice lvs
ext2spice ibex_wrapper.ext
feedback save /openLANE_flow/designs/ibex_wrapper/runs/18-12_18-19/logs/magic/magic_ext2spice.feedback.txt
# exec cp ibex_wrapper.spice /openLANE_flow/designs/ibex_wrapper/runs/18-12_18-19/results/magic/ibex_wrapper.spice

