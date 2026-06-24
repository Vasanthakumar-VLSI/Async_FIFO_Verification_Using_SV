vlib work
vlog list.svh
vsim -voptargs="-access=rw+/" work.top +Test_name=N_times +N=20
add wave -r sim:top/*
run -all

