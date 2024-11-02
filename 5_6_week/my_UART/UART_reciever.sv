`include "../../bank_modules.sv"

module UART_reciever # (parameter M=8)
(
  input reset,
  input clk,
  input bit_in,
  output reg [M-1:0] byte_out,
  output ready_out
);

reg [5:0] cnt_1;
reg [2:0] cnt_2;
reg [3:0] cnt_3;

initial begin
  cnt_1 = 0;
  cnt_2 = 0;
  cnt_3 = 0;
end

logic state;
logic read;

wire shift_wire;

assign shift_wire = (cnt_2==3);
assign ready_out = read;

shift_reg_con_in # ( .M(M)) con_in
  (
    .clk(clk),
    .reset(reset),
    .shift(shift_wire),
    .bit_in(bit_in),
    .byte_out(byte_out)
  );

always @(posedge clk)
begin
  if (reset)
  begin
    cnt_1 <= 0;
    cnt_2 <= 0;
    cnt_3 <= 0;
    read <= 0;
  end else
      begin
        if (bit_in == 0 || state == 1)
        begin
          cnt_1 <= cnt_1 + 1;
          if (cnt_1 == 35)
          begin
            state <= 0;
            read <= 0;
            cnt_1 <= 0;
          end
          if (cnt_1 == 2)
          begin
            state <= 1;
            read <= 0;
            cnt_2 <= 0;
          end else
              begin
                cnt_2 <= cnt_2 + 1;
                if (cnt_2 == 3)
                begin
                  cnt_2 <= 0;
                  if (cnt_3 == 7)
                  begin
                    read <= 1;
                    cnt_3 <= 0;
                  end else
                      begin
                        cnt_3 <= cnt_3 + 1;
                      end
                end
              end
              
        end
      end
end

endmodule