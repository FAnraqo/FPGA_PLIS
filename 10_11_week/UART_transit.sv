module UART_transit
	(
    input sb0,
		input wire bit_in,
    input clk,
    output wire bit_out,
    output wire [7:0] led_bus
	);
	
	logic areset;
	assign areset = ~ sb0;
	reg reset;
	always @ (posedge clk)   reset <= areset;
   
	wire [7:0] byte_out1;
  wire [7:0] byte_out2;

  wire ready1;
  wire ready_buf;
	wire xxx;
	wire enbl = ready_buf && ~ xxx;

  assign led_bus = byte_out2;
	wire clk_4;

	reg[0:8-1]result = 8'b00000000;

	reg [7:0] temp_byte;
	reg [0:3] bits_in;
	reg [0:6] byte_out;
  reg ready;

	reg [0:3]bits_out;

	always @(posedge clk_4) begin
		bits_in <= {temp_byte[$size(temp_byte)-5:$size(temp_byte)-1]};
    temp_byte <= {4'b0000,temp_byte[0:$size(temp_byte)-5]};
		if (ready1)begin
			temp_byte <= byte_out2;
		end
    if (ready) begin
      result <= {bits_out[0:3],result[0:$size(result)-5]};
    end
  end

	my_pll pll_inst
  (
		.areset(1'b0),
		.inclk0(clk),
		.c0(clk_4),
		.locked() 
  );

  UART_reciever reciever (
		.reset(reset), 
		.clk(clk_4),
		.bit_in(bit_in), 
		.byte_out(byte_out1),
		.ready_out(ready1)
	);

	UART_buffer buffer (
		.clk(clk_4), 
		.reset(reset), 
		.enable(ready1),
		.byte_in(byte_out1), 
		.byte_out(byte_out2), 
		.ready(ready_buf)
	);

	encoding encod (
		.clk(clk_4),
		.reset(reset),
		.bits_in(bits_in),
		.active(enbl),
		.byte_out(byte_out),
		.ready(ready)
	);

	decoding decod (
		.clk(clk_4),
		.reset(reset),
		.byte_in(byte_out),
		.active(enbl),
		.ready(ready),
		.bits_out()
	);
	
	UART_transmitter transmitter (
		.reset(reset), 
		.clk(clk_4), 
		.byte_in(result), 
		.enable(enbl),
		.bit_out(bit_out),
		.busy(xxx)
	);
    
endmodule
