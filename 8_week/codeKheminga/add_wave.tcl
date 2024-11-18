add wave -position insertpoint  \
sim:/testbanch/clk \
sim:/testbanch/cnt_taktov \
sim:/testbanch/reset \
sim:/testbanch/start \
sim:/testbanch/active \
sim:/testbanch/clk2 \
sim:/testbanch/bits_in \
sim:/testbanch/byte_out \
sim:/testbanch/shift

radix signal sim:/testbanch/cnt_taktov -unsigned

add wave -position insertpoint  \
sim:/testbanch/encoding/byte_out \
sim:/testbanch/encoding/ready \
sim:/testbanch/encoding/verification_matrix \
sim:/testbanch/encoding/encod_bits \
sim:/testbanch/encoding/cnt_2 \
sim:/testbanch/encoding/ready_tmp

add wave -position insertpoint  \
sim:/testbanch/decoding/bits_out \
sim:/testbanch/decoding/syndromes \
sim:/testbanch/decoding/cnt_2 \
sim:/testbanch/decoding/ready_tmp \
sim:/testbanch/decoding/error