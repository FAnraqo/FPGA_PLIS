`include "../../bank_modules.sv"

module testbanch;

  localparam cnt_width = 8;

  reg clk_4;
  reg [cnt_width-1:0] cnt_taktov;

  initial begin
    clk_4 = 0;
    cnt_taktov = 0;
  end

  always @(posedge clk_4) begin
    cnt_taktov <= cnt_taktov + 1;
    if (cnt_taktov == 200) begin
      $stop;
    end
  end

  always
    #10 clk_4 = ~clk_4;

  wire reset = (cnt_taktov == 3);
  wire start = (cnt_taktov == 5);
  wire active;

  reg [96-1:0]test_in = 96'b11111111_0000_1111_0000_0000_1111_0000_1111_0000_1111_11111111_0000_1111_0000_1111_0000_1111_0000_0000_1111_11111111;
  //10010101 10101001

  wire bit_in;
  reg [cnt_width-1:0]byte_out1;
  wire ready1;

  reg [cnt_width-1:0]byte_out2;
  wire ready2;
  wire bit_out;

  assign bit_in = test_in[$size(test_in)-1];

  trigger_x tr_x 
  (
    .clk(clk_4),
    .reset(reset),
    .set(start),
    .out(active)
  );

  always @(posedge clk_4) begin
    if (active) begin
      test_in <= {test_in[$size(test_in)-2:0], 1'b0};
    end
  end

  UART_reciever # (.M(cnt_width)) reciever
  (
    .clk(clk_4), 
    .reset(reset),
    .bit_in(bit_in), 
    .byte_out(byte_out1),
    .ready_out(ready1)
  );

  UART_buffer buffer
  (
    .clk(clk_4), 
    .reset(reset), 
    .enable(ready1),
    .byte_in(byte_out1), 
    .byte_out(byte_out2), 
    .ready(ready2)
  );

  UART_transmitter # (.M(cnt_width)) transmitter
  (
    .clk(clk_4), 
    .reset(reset), 
    .enable(ready2),
    .byte_in(byte_out2), 
    .bit_out(bit_out)
  );

endmodule