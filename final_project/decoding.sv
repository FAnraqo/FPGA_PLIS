module decoding
  (
    input reset,
    input clk,
    input active,
    input mode,
    input reg [0:7] byte_in,
    output reg ready,
    output reg [0:3] bits_out
  );

  reg [0:2] syndromes;
  reg [2:0] cnt_2;

  reg error;

  always @(posedge clk) begin

    if (reset) begin

      bits_out <= 0;
      error <= 0;
      cnt_2 <= 0;

    end
    
    else begin

      if (active && mode) begin

        error <= (byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) | (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) | (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]);

        bits_out[0] <= byte_in[0] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & ~(byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
        bits_out[1] <= byte_in[1] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & ~(byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
        bits_out[2] <= byte_in[2] ^ (~(byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));
        bits_out[3] <= byte_in[3] ^ ((byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4]) & (byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5]) & (byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6]));

        ready <= 1;

      end

      if (error) error <= 0;

      if (ready) ready <= 0;

    end
  end

endmodule