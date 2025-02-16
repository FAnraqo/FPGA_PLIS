`include "../../bank_modules.sv"

module UART_transmitter # (parameter M=8)
  (
    input reset,
    input clk,
    input reg [M-1:0] byte_in,
    input enable,
    output bit_out,
    output busy 
  );

  reg [2:0] cnt_2;
  reg [4:0] cnt_3;

  logic sw;
  logic tr_next;

  wire shift_wire;
  wire set_wire;
  wire uart_0;
  wire next_byte;

  initial begin
    cnt_2 = 0;
    cnt_3 = 0;
  end

  shift_reg_par_in # ( .M(10)) par_in
    (
      .clk(clk),
      .reset(reset),
      .bus_in({1'b1, byte_in, 1'b0}),
      .set(set_wire),
      .shift(shift_wire),
      .bit_out(uart_0)
    );

  assign shift_wire = (cnt_2 == 3);
  assign set_wire = (enable == 1 && sw == 0);
  assign bit_out = sw ? uart_0 : 1;
  assign busy = sw;
  assign next_byte = tr_next;

  always @(posedge clk)
  begin
    if (reset) begin
      cnt_2 <= 0;
      cnt_3 <= 0;
      sw <= 0;
      tr_next <= 0;
    end else begin
          if (enable == 1 && sw == 0) begin
            sw <= 1;
            cnt_2 <= 0;
          end
          if (sw == 1) begin
            cnt_2 <= cnt_2 + 1;
            tr_next <= 0;
            if (cnt_2 == 3) begin
                cnt_2 <= 0;
                cnt_3 <= cnt_3 + 1;
            end
            if (cnt_3 == 9) begin
                sw <= 0;
                cnt_3 <= 0;
            end
          end
        end
  end

endmodule