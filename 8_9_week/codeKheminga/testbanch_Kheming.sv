`include "./encoding.sv"
`include "./decoding.sv"

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

  reg[0:16-1]test_in = 16'b1011011100001000;
  reg[0:16-1]result = 16'b0000000000000000;

  reg [0:3]bits_in = 4'b0000;
  reg [0:6]byte_out;
  reg ready;

  reg [0:3]bits_out;


  trigger_x tr_x
  (
    .clk(clk),
    .reset(reset),
    .set(start),
    .out(active)
  );

  always @(posedge clk) begin
    if (active) begin
      bits_in <= {test_in[$size(test_in)-5:$size(test_in)-1]};
      test_in <= {4'b0000,test_in[0:$size(test_in)-5]};
    end
    if (ready) begin
      result <= {bits_out[0:3],result[0:$size(result)-5]};
    end
  end

  encoding # ( .M(4)) encoding
    (
      .reset(reset),
      .clk(clk),
      .bits_in(bits_in),
      .active(active),
      .byte_out(byte_out),
      .ready(ready)
    );

  decoding # ( .M(4)) decoding
  (
    .reset(reset),
    .clk(clk),
    .byte_in(byte_out),
    .active(active),
    .ready(ready),
    .bits_out(bits_out)
  );

endmodule