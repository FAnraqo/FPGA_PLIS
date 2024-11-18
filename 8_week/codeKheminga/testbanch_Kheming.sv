module testbanch;

  reg clk;
  reg [7:0] cnt_taktov;

  initial begin
    clk = 0;
    cnt_taktov = 0;
  end

  always
    #10 clk = ~clk;

  always @(posedge clk) begin
    cnt_taktov <= cnt_taktov + 1;
    if (cnt_taktov == 20)begin
      $stop;
    end
  end

  wire reset = (cnt_taktov == 3);
  wire start = (cnt_taktov == 5);
  wire active;
  wire clk2;

  reg [0:3]bits_in = 4'b1010;
  reg [0:6]byte_out;
  reg ready;

  reg [0:6]bits_out;


  trigger_x tr_x (.clk(clk), .reset(reset), .set(start), .out(active));

  trigger_d tr_d (.clk(clk), .reset(reset), .set(~clk2), .out(clk2));

  assign shift = active & clk2;

  encoding # ( .M(4)) encoding
    (
      .reset(reset),
      .clk(clk),
      .bits_in(bits_in),
      .shift(shift),
      .byte_out(byte_out),
      .ready(ready)
    );

  decoding # ( .M(4)) decoding
  (
    .reset(reset),
    .clk(clk),
    .byte_in(byte_out),
    .shift(shift),
    .ready(ready),
    .bits_out(bits_out)
  );

endmodule