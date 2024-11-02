module UART_transit
    (
        input wire bit_in,
        input wire clk,
        input wire reset,
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
	 
    wire clk_4;

    assign led_bus = byte_out2;

    my_pll pll (
        .inclk0(clk),
        .areset(1'b0),
        .c0(clk_4),
        .locked()
    );
	 
    UART_reciever receiver (
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

    UART_transmitter transmitter (
        .clk(clk_4), 
        .reset(reset), 
        .enable(enbl),
        .byte_in(byte_out2), 
        .bit_out(bit_out),
        .busy(xxx)
    );

endmodule
