add wave -position insertpoint  \
sim:/testbench/clk \
sim:/testbench/counter \
sim:/testbench/reset \
sim:/testbench/start \
sim:/testbench/active \
sim:/testbench/test_in \
sim:/testbench/led_bus \
sim:/testbench/result 

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
sim:/testbench/cnt_1

radix signal sim:/testbench/cnt_1 -unsigned

add wave -position insertpoint  \
sim:/testbench/encod/active \
sim:/testbench/encod/bits_in \
sim:/testbench/encod/byte_out \
sim:/testbench/encod/ready 

add wave -position insertpoint  \
sim:/testbench/decod/byte_in \
sim:/testbench/decod/ready \
sim:/testbench/decod/bits_out \
sim:/testbench/decod/syndromes \
sim:/testbench/decod/error

add wave -position insertpoint  \
sim:/testbench/cnt_2 \
sim:/testbench/ready_tra_in

radix signal sim:/testbench/cnt_2 -unsigned

add wave -position insertpoint  \
sim:/testbench/transmitter/byte_in \
sim:/testbench/transmitter/enable \
sim:/testbench/transmitter/bit_out \
sim:/testbench/transmitter/busy