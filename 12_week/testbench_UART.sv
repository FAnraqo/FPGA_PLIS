module testbench;

    localparam cnt_width = 8;

    reg clk;
    reg [cnt_width-1:0] counter;

    initial begin
        clk = 0;
        counter = 0;
    end

    always @(posedge clk) begin
        counter <= counter + 1;
        if (counter == 200) begin
            $stop;
        end
    end

    always
        #10 clk = ~clk;

    wire reset = (counter == 3);
    wire start = (counter == 5);
    wire active;

    reg [52-1:0]test_in = 52'b11111111_0000_1111_0000_0000_1111_0000_1111_0000_1111_11111111; 
    //10010101

    wire [7:0] byte_out1;
    wire [7:0] byte_out2;

    wire ready1;
    wire ready_buf;
	wire xxx;
	

    assign led_bus = byte_out2;

    reg[0:8-1]result = 8'b00000000;

	reg [0:7] temp_byte;
	reg [0:3] bits_in;
	reg [0:6] byte_out;
    reg ready;

	reg [0:3]bits_out;

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

	encoding encod (
		.clk(clk),
		.reset(reset),
		.bits_in(bits_in),
		.active(ready_enc_in),
		.byte_out(byte_out),
		.ready(ready)
	);

	decoding decod (
		.clk(clk),
		.reset(reset),
		.byte_in(byte_out),
		.ready(ready),
		.bits_out(bits_out)
	);
	
	UART_transmitter transmitter (
		.reset(reset), 
		.clk(clk), 
		.byte_in(result), 
		.enable(enbl),
		.bit_out(bit_out),
		.busy(xxx)
	);

endmodule