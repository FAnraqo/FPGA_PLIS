module decoding
  (
    input reset,
    input clk,
    input reg [0:6] byte_in,
    input reg ready,
    output reg [0:3] bits_out
  );

  reg [20:0] verification_matrix;
  reg [0:2] syndromes;
  reg [2:0] cnt_2;

  logic ready_tmp;
  logic error;

  initial begin
    verification_matrix = 21'b110110010110100111001;
    cnt_2 = 0;
  end

  always @(posedge clk)
  begin
    if (reset) begin
      bits_out <= 0;
      ready_tmp <= 1;
      error <= 0;
      cnt_2 <= 0;
    end else  begin

          if (ready_tmp == 1 && ready == 1) begin

            error <= (byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) | (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) | (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]);

            bits_out[0] <= byte_in[0] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & ~(byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
            bits_out[1] <= byte_in[1] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & ~(byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
            bits_out[2] <= byte_in[2] ^ (~(byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
            bits_out[3] <= byte_in[3] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));

          end
        end
  end

endmodule