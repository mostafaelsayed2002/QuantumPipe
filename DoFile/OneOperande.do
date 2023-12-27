add wave -position 0  sim:/quantum_pipe/M/clk
add wave -position 1  sim:/quantum_pipe/int
add wave -position 2  sim:/quantum_pipe/reset
add wave -position 3  sim:/quantum_pipe/F/pc
add wave -position end  sim:/quantum_pipe/D/RF/R0
add wave -position end  sim:/quantum_pipe/D/RF/R1
add wave -position end  sim:/quantum_pipe/D/RF/R2
add wave -position end  sim:/quantum_pipe/D/RF/R3
add wave -position end  sim:/quantum_pipe/D/RF/R4
add wave -position end  sim:/quantum_pipe/D/RF/R5
add wave -position end  sim:/quantum_pipe/D/RF/R6
add wave -position end  sim:/quantum_pipe/D/RF/R7
add wave -position end  sim:/quantum_pipe/D/RF/CCR
add wave -position end  sim:/quantum_pipe/M/Sp
add wave -position end  sim:/quantum_pipe/in_port
add wave -position end  sim:/quantum_pipe/out_port

force -freeze sim:/quantum_pipe/int 0 0
force -freeze sim:/quantum_pipe/reset 1 0

run
run

force -freeze sim:/quantum_pipe/reset 0 0

run
run
run
run

force -freeze sim:/quantum_pipe/in_port X\"00000005\" 0
run
force -freeze sim:/quantum_pipe/in_port X\"00000010\" 0
run