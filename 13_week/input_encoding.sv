module input_encoding
  (
    input reset,
    input clk,
    input active,
    input mode,
    input busy,
    input reg [0:7] byte_in,
    output reg [0:3] bits_out,
    output reg ready
  );

  reg [0:7]temp_byte;
  reg ready_tmp;
  reg wait_out;
  reg cnt_1;
  reg cnt_2;
  reg [0:2]cnt_5;

  always @(posedge clk)
  begin
    if (reset) begin
      bits_out <= 0;
      ready_tmp <= 0;
      wait_out <= 0;
      ready <= 0;
      cnt_1 <= 0;
      cnt_2 <= 0;
      cnt_5 <= 0;
    end else  begin
          if (active && ~ mode) begin
            ready_tmp <= 1;
          end
          if (ready_tmp && ~ wait_out && ~ cnt_2)begin
            temp_byte <= byte_in;
            cnt_1 <= 1;
            
          end

          if (cnt_1) begin
            if (~ wait_out) begin

              if (cnt_5 == 1) begin
                bits_out <= {temp_byte[0:$size(temp_byte)-5]};
                temp_byte <= {temp_byte[$size(temp_byte)-4:$size(temp_byte)-1], 4'b0000};
                cnt_2 <= cnt_2 + 1;
              end
              
              ready <= 1;
            end

            cnt_5 <= cnt_5 + 1;

            if (cnt_5 == 1) begin
              ready <= 0;
              wait_out <= 1;
            end

            if (cnt_5 == 5 && ~ busy) begin
              wait_out <= 0;
              cnt_5 <= 0;
              cnt_1 <= 0;
            end

            if (~wait_out && cnt_2) begin
              ready_tmp <= 0;
            end

          end

          if (~wait_out && cnt_2) cnt_1 <= 1;
            
        end
  end

endmodule