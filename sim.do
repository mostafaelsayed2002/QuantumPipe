add wave -position end  sim:/quantum_pipe/clk
add wave -position end  sim:/quantum_pipe/pcval
add wave -position end  sim:/quantum_pipe/instr
add wave -position end  sim:/quantum_pipe/Data_R1
add wave -position end  sim:/quantum_pipe/Data_R2
add wave -position end  sim:/quantum_pipe/Excute_Result
add wave -position end  sim:/quantum_pipe/MemDataOut
add wave -position end  sim:/quantum_pipe/Rdst_WB_data
add wave -position end  sim:/quantum_pipe/D_Write_Back
add wave -position end  sim:/quantum_pipe/D_Write_Back_2
add wave -position end  sim:/quantum_pipe/D_Write_Back_Source
add wave -position end  sim:/quantum_pipe/D_Memory_Read
add wave -position end  sim:/quantum_pipe/D_Memory_Write
add wave -position end  sim:/quantum_pipe/D_Port_Read
add wave -position end  sim:/quantum_pipe/D_Port_Write
add wave -position end  sim:/quantum_pipe/in_port
add wave -position end  sim:/quantum_pipe/out_port

--------------------------


add wave -position end  sim:/quantum_pipe/D/RF/R0
add wave -position end  sim:/quantum_pipe/D/RF/R1
add wave -position end  sim:/quantum_pipe/D/RF/R2
add wave -position end  sim:/quantum_pipe/D/RF/R3
add wave -position end  sim:/quantum_pipe/D/RF/R4
add wave -position end  sim:/quantum_pipe/D/RF/R5
add wave -position end  sim:/quantum_pipe/D/RF/R6
add wave -position end  sim:/quantum_pipe/D/RF/R7
add wave -position end  sim:/quantum_pipe/D/RF/CCR
add wave -position 2  sim:/quantum_pipe/F/pc
add wave -position end  sim:/quantum_pipe/M/Sp
add wave -position 0  sim:/quantum_pipe/M/clk
add wave -position 0  sim:/quantum_pipe/clk
add wave -position 1  sim:/quantum_pipe/int
add wave -position end  sim:/quantum_pipe/in_port
add wave -position end  sim:/quantum_pipe/out_port
add wave -position 2  sim:/quantum_pipe/reset
add wave -position 3  sim:/quantum_pipe/F/pc





force -freeze sim:/quantum_pipe/int 0 0
force -freeze sim:/quantum_pipe/reset 1 0