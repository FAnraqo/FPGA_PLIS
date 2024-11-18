module decoding # (parameter M=4)
  (
    input reset,
    input clk,
    input reg [0:6] byte_in,
    input shift,
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
    syndromes = 3'b000;
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
          if (shift == 1 && ready_tmp == 1 && ready == 1) begin

            if (cnt_2 == 1) begin
                ready_tmp <= 0;
            end

            if (ready_tmp == 1)begin
              syndromes[0] <= syndromes[0] ^ byte_in[0] ^ byte_in[1] ^ byte_in[3] ^ byte_in[4];
              syndromes[1] <= syndromes[1] ^ byte_in[0] ^ byte_in[2] ^ byte_in[3] ^ byte_in[5];
              syndromes[2] <= syndromes[2] ^ byte_in[1] ^ byte_in[2] ^ byte_in[3] ^ byte_in[6];
            end

            error <= syndromes[0] | syndromes[1] | syndromes[2];

            bits_out[0] <= byte_in[0] ^ (syndromes[0] & syndromes[1] & ~syndromes[2]);
            bits_out[1] <= byte_in[1] ^ (syndromes[0] & ~syndromes[1] & syndromes[2]);
            bits_out[2] <= byte_in[2] ^ (~syndromes[0] & syndromes[1] & syndromes[2]);
            bits_out[3] <= byte_in[3] ^ (syndromes[0] & syndromes[1] & syndromes[2]);

            cnt_2 <= cnt_2 + 1;
          end
        end
  end

endmodule