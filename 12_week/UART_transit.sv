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

  assign led_bus = byte_out2;
	wire clk_4;

	reg[0:8-1]result = 8'b00000000;

	reg [7:0] temp_byte = 8'b00000000;
	reg [0:3] bits_in = 4'b0000;
	reg [0:6] byte_out = 7'b0000000;
  reg ready;

	reg [0:3]bits_out = 4'b0000;

	reg ready_enc_in;
	reg [0:1]cnt_1;
	
	reg ready_tra_in;
	reg [0:1]cnt_2;

	initial begin
			ready_enc_in = 0;
			cnt_1 = 0;
			ready_tra_in = 0;
			cnt_2 = 0;
	end

	wire enbl = ready_tra_in && ~ xxx;

	always @(posedge clk) begin
		bits_in <= {temp_byte[$size(temp_byte)-5:$size(temp_byte)-1]};
		temp_byte <= {4'b0000,temp_byte[0:$size(temp_byte)-5]};

		if (ready_buf) begin
			temp_byte <= byte_out2;
			ready_enc_in <= 1;
		end

		if (ready_enc_in) begin
			cnt_1 <= cnt_1 + 1;
		end
		
		if (cnt_1 == 2) begin
			ready_enc_in <= 0;
			cnt_1 <= 0;
		end

		if (ready) begin
			result <= {bits_out[0:3],result[0:$size(result)-5]};
			cnt_2 <= cnt_2 + 1;
		end

		if (cnt_2 == 2) begin
			ready_tra_in <= 1;
			cnt_2 <= 0;
		end

		if (ready_tra_in) begin
			ready_tra_in <= 0;
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
		.active(ready_enc_in),
		.byte_out(byte_out),
		.ready(ready)
	);

	decoding decod (
		.clk(clk_4),
		.reset(reset),
		.byte_in(byte_out),
		.ready(ready),
		.bits_out(bits_in)
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
