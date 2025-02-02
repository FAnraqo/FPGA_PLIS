add wave -position insertpoint  \
sim:/testbench/clk \
sim:/testbench/counter \
sim:/testbench/reset \
sim:/testbench/start \
sim:/testbench/active \
sim:/testbench/test_in \
sim:/testbench/led_bus 

radix signal sim:/testbench/counter -unsigned

add wave -position insertpoint  \
sim:/testbench/reciever/bit_in \
sim:/testbench/reciever/byte_out \
sim:/testbench/reciever/ready_out 

add wave -position insertpoint  \
sim:/testbench/buffer/byte_in \
sim:/testbench/buffer/byte_out \
sim:/testbench/buffer/ready

add wave -position insertpoint  \
sim:/testbench/in_encod/active \
sim:/testbench/in_encod/mode \
sim:/testbench/in_encod/ready_tmp \
sim:/testbench/in_encod/temp_byte \
sim:/testbench/in_encod/wait_out \
sim:/testbench/in_encod/byte_in \
sim:/testbench/in_encod/bits_out \
sim:/testbench/in_encod/ready \
sim:/testbench/in_encod/busy \
sim:/testbench/in_encod/cnt_1 \
sim:/testbench/in_encod/cnt_2 \
sim:/testbench/in_encod/cnt_5

add wave -position insertpoint  \
sim:/testbench/encod/active \
sim:/testbench/encod/bits_in \
sim:/testbench/encod/byte_out \
sim:/testbench/encod/cnt_2 \
sim:/testbench/encod/ready 

add wave -position insertpoint  \
sim:/testbench/decod/active \
sim:/testbench/decod/mode \
sim:/testbench/decod/byte_in \
sim:/testbench/decod/ready \
sim:/testbench/decod/bits_out \
sim:/testbench/decod/syndromes \
sim:/testbench/decod/cnt_2 \
sim:/testbench/decod/error

add wave -position insertpoint  \
sim:/testbench/out_decod/active \
sim:/testbench/out_decod/busy \
sim:/testbench/out_decod/bits_in \
sim:/testbench/out_decod/ready \
sim:/testbench/out_decod/byte_out \
sim:/testbench/out_decod/ready_tmp \
sim:/testbench/out_decod/cnt_2

add wave -position insertpoint  \
sim:/testbench/transmitter/byte_in \
sim:/testbench/transmitter/enable \
sim:/testbench/transmitter/bit_out \
sim:/testbench/transmitter/busy