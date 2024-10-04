module testbench;

// Параметры
localparam cnt_width = 5;

reg clk;
reg [cnt_width-1:0] cnt_taktov;

initial begin
  clk = 0;
  cnt_taktov = 0;
end

always
  #10 clk = ~ clk;

always @(posedge clk) begin
  cnt_taktov <= cnt_taktov + 1;
  if (cnt_taktov == 18) begin
    $stop;
  end
end



// Входы и выходы регистров
wire reset = (cnt_taktov == 3);
wire start = (cnt_taktov == 5);
wire active;
wire data;
wire [cnt_width-1:0]byte_1 = 8'h11; // узнать можно ли 8 задать переменной?
wire [cnt_width-1:0]byte_out;
wire clk2;


trigger_x tr_x (
  .clk(clk), .reset(reset),
  .set(start), .out(active));

trigger_d tr_d (
  .clk(clk), .reset(reset),
  .set(~clk2), .out(clk2));

assign shift = active & clk2;


shift_reg_par_in # ( .M(cnt_width)) par_in
  (
    .clk(clk),
    .reset(reset),
    .set(start),
    .shift(shift),
    .bus_in(byte_1),
    .bit_out(data)
  );

shift_reg_con_in # ( .M(cnt_width)) con_in
  (
    .clk(clk),
    .reset(reset),
    .shift(shift),
    .bit_in(data),
    .byte_out(byte_out)
  );

endmodule