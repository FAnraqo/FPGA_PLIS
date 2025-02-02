module testbench;

    localparam cnt_width = 8;

    reg clk;
    reg [10-1:0] counter;

    initial begin
        clk = 0;
        counter = 0;
    end

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 400) begin
            $stop;
        end
    end

    always
        #10 clk = ~clk;

    wire reset = (counter == 3);
    wire start = (counter == 5);
    wire active;


    reg mode = 1;
    
    //reg [52-1:0]test_in = 52'b11111111_0000_0000_0000_1111_1111_0000_0000_0000_1111_11111111; 
    //00110001

    //reg [140-1:0]test_in = 140'b11111111_0000_1111_0000_0000_1111_0000_0000_1111_0000_11111111_0000_1111_0000_1111_0000_1111_0000_1111_0000_11111111_0000_1111_0000_1111_0000_1111_0000_1111_0000_11111111;
    //10010010 10101010 10101010

    //reg [187-1:0]test_in = 187'b11111111_0000_0000_0000_1111_1111_0000_0000_0000_1111_11111111_0000_0000_0000_0000_0000_0000_0000_0000_0000_11111111111_0000_0000_0000_0000_0000_0000_0000_0000_0000_11111111_0000_0000_0000_1111_1111_0000_0000_0000_1111_11111111;
    //00110001 00000000 00000000 00110001

    reg [231-1:0]test_in = 231'b11111111_0000_0000_0000_1111_1111_1111_0000_0000_0000_11111111_0000_0000_0000_0000_1111_1111_1111_1111_0000_11111111111_0000_0000_0000_0000_0000_0000_0000_0000_0000_11111111_0000_0000_0000_1111_1111_1111_0000_1111_1111_11111111_0000_0000_0000_0000_1111_1111_1111_1111_0000_11111111;
    //00110001 00000000 00000000 00110001

    wire [7:0] byte_out1;
    wire [7:0] byte_out2;

    wire ready1;
    wire ready2;
    wire ready_buf;
	wire xxx;
	

    assign led_bus = byte_out2;

	reg [7:0] byte_out;

	reg [0:3] bits_out;

    reg ready_enc;
    reg ready_dec;

    reg [7:0] byte_out_enc;
    reg [7:0] byte_out_dec;

    wire enbl = (ready_enc || ready_dec) && ~ xxx;

    reg ready_in;
    reg [0:3]bits_in;

    

    trigger_x trigger_x (
        .clk(clk), .set(start),
        .reset(reset), .out(active)
    );

    always @(posedge clk) begin
        if (active) begin
            test_in <= {test_in[$size(test_in)-2:0], 1'b0};
        end
    end

    assign bit_in = test_in[$size(test_in)-1];

    always @(posedge clk) begin

        if (~ mode) begin
            
            byte_out <= byte_out_enc;

        end

        else begin

            byte_out <= byte_out_dec;

        end

    end

    UART_reciever reciever (
		.reset(reset), 
		.clk(clk),
		.bit_in(bit_in), 
		.byte_out(byte_out1),
		.ready_out(ready1)
	);

	UART_buffer buffer (
		.clk(clk), 
		.reset(reset), 
		.enable(ready1),
		.byte_in(byte_out1), 
		.byte_out(byte_out2), 
		.ready(ready_buf)
	);

    input_encoding in_encod (
        .clk(clk),
        .reset(reset),
        .active(ready_buf),
        .mode(mode),
        .busy(xxx),
        .byte_in(byte_out2),
        .bits_out(bits_in),
        .ready(ready_in)
    );

	encoding encod (
		.clk(clk),
		.reset(reset),
        .active(ready_in),
		.bits_in(bits_in),
		.byte_out(byte_out_enc),
		.ready(ready_enc)
	);

	decoding decod (
		.clk(clk),
		.reset(reset),
        .active(ready_buf),
        .mode(mode),
		.byte_in(byte_out2),
		.bits_out(bits_out),
        .ready(ready2)
	);

    output_decoding out_decod (
        .clk(clk),
        .reset(reset),
        .active(ready2),
        .busy(xxx),
        .bits_in(bits_out),
        .byte_out(byte_out_dec),
        .ready(ready_dec)
    );
	
	UART_transmitter transmitter (
		.reset(reset), 
		.clk(clk), 
		.byte_in(byte_out), 
		.enable(enbl),
		.bit_out(bit_out),
		.busy(xxx)
	);

endmodule