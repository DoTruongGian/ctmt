onerror {quit -f}
vlib work
vlog -work work single_cycle.vo
vlog -work work single_cycle.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.single_cycle_vlg_vec_tst
vcd file -direction single_cycle.msim.vcd
vcd add -internal single_cycle_vlg_vec_tst/*
vcd add -internal single_cycle_vlg_vec_tst/i1/*
add wave /*
run -all
