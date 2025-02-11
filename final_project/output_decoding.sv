module output_decoding
  (
    input reset,
    input clk,
    input active,
    input busy,
    input reg [0:3] bits_in,
    output reg ready,
    output reg [0:7] byte_out
  );

  reg ready_tmp;
  reg [0:1] cnt_2;

  always @(posedge clk) begin

    if (reset) begin

      byte_out <= 0;
      ready_tmp <= 0;
      ready <= 0;
      cnt_2 <= 0;

    end

    else begin

      if (active) begin

        byte_out <= {byte_out[$size(byte_out)-4:$size(byte_out)-1], bits_in[0:3]};
        cnt_2 <= cnt_2 + 1;
      
      end

      if (cnt_2 == 2) begin

        ready_tmp <= 1;
        cnt_2 <= 0;

      end

      if (ready_tmp && ~ busy) begin

        ready <= 1;
        ready_tmp <= 0;

      end

      if (ready) begin

        ready <= 0;
        byte_out <= 8'b00000000;

      end

    end

  end

endmodule