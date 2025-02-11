module encoding
  (
    input reset,
    input clk,
    input active,
    input reg [0:3] bits_in,
    output reg [0:7] byte_out,
    output reg ready
  );

  reg ready_tmp;
  reg [0:1] cnt_2;

  always @(posedge clk)
  begin
    if (reset) begin
      byte_out <= 0;
      ready_tmp <= 0;
      ready <= 0;
      cnt_2 <= 0;
    end else begin

          if (active)begin
            ready_tmp <= 1;
          end

          if (ready_tmp) begin

            byte_out[0] <= bits_in[0];
            byte_out[1] <= bits_in[1];
            byte_out[2] <= bits_in[2];
            byte_out[3] <= bits_in[3];
            byte_out[4] <= bits_in[0] ^ bits_in[1] ^ bits_in[3];
            byte_out[5] <= bits_in[0] ^ bits_in[2] ^ bits_in[3];
            byte_out[6] <= bits_in[1] ^ bits_in[2] ^ bits_in[3];
            byte_out[7] <= (bits_in[0] || bits_in[1] || bits_in[2] || bits_in[3]) ^ 1;

            cnt_2 <= cnt_2 + 1;

            if (cnt_2 == 1) begin

              ready_tmp <= 0;

            end
            
          end

          if (cnt_2 == 1) begin

            cnt_2 <= cnt_2 + 1;
            ready <= 1;

          end

          if (cnt_2 == 2) begin

            ready <= 0;
            cnt_2 <= 0;

          end

        end
  end

endmodule