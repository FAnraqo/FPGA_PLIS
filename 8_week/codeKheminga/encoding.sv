module encoding # (parameter M=4)
  (
    input reset,
    input clk,
    input reg [0:3] bits_in,
    input shift,
    output reg [0:6] byte_out,
    output reg ready
  );

  reg [20:0] verification_matrix;
  reg [0:2] encod_bits;
  reg [2:0] cnt_2;

  logic ready_tmp;

  initial begin
    verification_matrix = 21'b110110010110100111001;
    encod_bits = 3'b000;
    cnt_2 = 0;
  end

  always @(posedge clk)
  begin
    if (reset) begin
      byte_out <= 0;
      ready_tmp <= 1;
      ready <= 0;
      cnt_2 <= 0;
    end else  begin
          if (shift == 1 && ready_tmp == 1) begin

            if (cnt_2 == 1) begin
              byte_out <= {bits_in[0:3], encod_bits[0:2]};
              byte_out[0] <= 0;

              ready_tmp <= 0;
              ready <= 1;
            end

            if (ready_tmp == 1)begin
              encod_bits[0] <= encod_bits[0] ^ bits_in[0] ^ bits_in[1] ^ bits_in[3];
              encod_bits[1] <= encod_bits[1] ^ bits_in[0] ^ bits_in[2] ^ bits_in[3];
              encod_bits[2] <= encod_bits[2] ^ bits_in[1] ^ bits_in[2] ^ bits_in[3];
            end

            cnt_2 <= cnt_2 + 1;
            
          end
        end
  end

endmodule