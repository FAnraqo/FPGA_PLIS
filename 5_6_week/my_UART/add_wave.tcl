add wave -position insertpoint  \
sim:/testbanch/clk_4 \
sim:/testbanch/cnt_taktov \
sim:/testbanch/reset \
sim:/testbanch/start \
sim:/testbanch/active \
sim:/testbanch/test_in 

radix signal sim:/testbanch/cnt_taktov -unsigned

add wave -position insertpoint  \
sim:/testbanch/reciever/clk \
sim:/testbanch/reciever/bit_in \
sim:/testbanch/reciever/byte_out \
sim:/testbanch/reciever/ready_out \
sim:/testbanch/reciever/cnt_1 \
sim:/testbanch/reciever/cnt_2 \
sim:/testbanch/reciever/cnt_3 \
sim:/testbanch/reciever/state \
sim:/testbanch/reciever/read \
sim:/testbanch/reciever/shift_wire

radix signal sim:/testbanch/reciever/cnt_1 -unsigned
radix signal sim:/testbanch/reciever/cnt_2 -unsigned 
radix signal sim:/testbanch/reciever/cnt_3 -unsigned

add wave -position insertpoint  \
sim:/testbanch/buffer/clk \
sim:/testbanch/buffer/byte_in \
sim:/testbanch/buffer/byte_out \
sim:/testbanch/buffer/ready

add wave -position insertpoint  \
sim:/testbanch/transmitter/clk \
sim:/testbanch/transmitter/byte_in \
sim:/testbanch/transmitter/enable \
sim:/testbanch/transmitter/bit_out \
sim:/testbanch/transmitter/cnt_2 \
sim:/testbanch/transmitter/cnt_3 \
sim:/testbanch/transmitter/sw \
sim:/testbanch/transmitter/tr_next \
sim:/testbanch/transmitter/shift_wire \
sim:/testbanch/transmitter/set_wire \
sim:/testbanch/transmitter/uart_0 

radix signal sim:/testbanch/transmitter/cnt_2 -unsigned 
radix signal sim:/testbanch/transmitter/cnt_3 -unsigned