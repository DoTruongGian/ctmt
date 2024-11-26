onerror {quit -f}
vlib work
vlog -work work pipeline.vo
vlog -work work pipeline.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.pipeline_vlg_vec_tst
vcd file -direction pipeline.msim.vcd
vcd add -internal pipeline_vlg_vec_tst/*
vcd add -internal pipeline_vlg_vec_tst/i1/*
add wave /*
run -all
