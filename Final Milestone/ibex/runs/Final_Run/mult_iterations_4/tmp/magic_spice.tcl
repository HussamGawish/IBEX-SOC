
lef read /pdks/sky130A/libs.ref/sky130_fd_sc_hd/techlef/sky130_fd_sc_hd.tlef
if {  [info exist ::env(EXTRA_LEFS)] } {
	set lefs_in $::env(EXTRA_LEFS)
	foreach lef_file $lefs_in {
		lef read $lef_file
	}
}
def read /openLANE_flow/designs/ibex/runs/mult_iterations_4/results/routing/ibex_core.def
load ibex_core -dereference
cd /openLANE_flow/designs/ibex/runs/mult_iterations_4/results/magic/
extract do local
extract no capacitance
extract no coupling
extract no resistance
extract no adjust
# extract warn all
extract

ext2spice lvs
ext2spice ibex_core.ext
feedback save /openLANE_flow/designs/ibex/runs/mult_iterations_4/logs/magic/magic_ext2spice.feedback.txt
# exec cp ibex_core.spice /openLANE_flow/designs/ibex/runs/mult_iterations_4/results/magic/ibex_core.spice

