add wave -position insertpoint  \
sim:/testbanch/cnt_taktov \
sim:/testbanch/test_in \
sim:/testbanch/bits_in \
sim:/testbanch/byte_out \

radix signal sim:/testbanch/cnt_taktov -unsigned

add wave -position insertpoint  \
sim:/testbanch/decoding/error \
sim:/testbanch/decoding/bits_out 

add wave -position insertpoint  \
sim:/testbanch/result 