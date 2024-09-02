onerror {quit -f}
vlib work
vlog -work work milestone1_test.vo
vlog -work work milestone1_test.vt
vsim -novopt -c -t 1ps -L cyclonev_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.milestone1_test_vlg_vec_tst
vcd file -direction milestone1_test.msim.vcd
vcd add -internal milestone1_test_vlg_vec_tst/*
vcd add -internal milestone1_test_vlg_vec_tst/i1/*
add wave /*
run -all
