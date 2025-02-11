module UART_transit
	(
    input sb0,
		input wire bit_in,
    input clk,
		input but,
    output wire bit_out,
    output wire [7:0] led_bus
	);
	
	logic areset;
	assign areset = ~ sb0;
	reg reset;
	always @ (posedge clk)   reset <= areset;
  
	wire x;
		
	reg mode = 0;

	always @ (posedge clk) begin

		mode <= x;

	end

  wire [7:0] byte_out1;
  wire [7:0] byte_out2;

  wire ready1;
  wire ready_buf;
  wire xxx;

  assign led_bus[0] = mode;
	wire clk_4;

	reg [0:3] bits_in = 4'b0000;
	reg [7:0] byte_out = 8'b00000000;

	reg [0:3] bits_out = 4'b0000;

	reg ready_enc;
	reg ready_dec;

	reg [0:7] byte_out_enc;
	reg [0:7] byte_out_dec;

	wire enbl = (ready_enc || ready_dec) && ~ xxx;

	reg ready_in;

	always @(posedge clk) begin

		if (~ mode) begin
				
			byte_out <= byte_out_enc;

		end

		else begin

			byte_out <= byte_out_dec;

		end

	end

	my_pll pll_inst
  (
		.areset(1'b0),
		.inclk0(clk),
		.c0(clk_4),
		.locked() 
  );

	trigger_d tri_d (
		.clk(but),
		.reset(reset),
		.set(~ x),
		.out(x)
	);

  UART_reciever reciever (
		.clk(clk_4),
		.reset(reset),
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

	input_encoding in_encod (
		.clk(clk_4),
		.reset(reset),
		.active(ready_buf),
		.mode(mode),
		.busy(xxx),
		.byte_in(byte_out2),
		.bits_out(bits_in),
		.ready(ready_in)
	);

	encoding encod (
		.clk(clk_4),
		.reset(reset),
    .active(ready_in),
		.bits_in(bits_in),
		.byte_out(byte_out_enc),
		.ready(ready_enc)
	);

	decoding decod (
		.clk(clk_4),
		.reset(reset),
		.active(ready_buf),
		.mode(mode),
		.byte_in(byte_out2),
		.bits_out(bits_out),
		.ready(ready2)
	);

	output_decoding out_decod (
		.clk(clk_4),
		.reset(reset),
		.active(ready2),
		.busy(xxx),
		.bits_in(bits_out),
		.byte_out(byte_out_dec),
		.ready(ready_dec)
	);
	
	UART_transmitter transmitter (
		.clk(clk_4),
		.reset(reset),
		.byte_in(byte_out), 
		.enable(enbl),
		.bit_out(bit_out),
		.busy(xxx)
	);
    
endmodule
