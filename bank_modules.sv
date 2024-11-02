module trigger_x   
   (input clk,
    input reset,
    input set,
    output reg out
    );
    always @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else begin
            if (set) begin
                out <= 1;
            end
        end
    end
endmodule

module trigger_d   
   (input clk,
    input reset,
    input set,
    output reg out
    );
    always @(posedge clk) begin
        if (reset) begin
            out <= 0;
        end else begin
                out <= set;
        end
    end
endmodule

module shift_reg_con_in # (parameter M=5)  // объявляем значение параметра равным 5
(
  input clk,                             // входы по умолчанию имеют тип wire
  input reset,
  input bit_in,
  input shift,
	output reg [M-1:0] byte_out               // объявляем тип выхода  шина reg
);

always @(posedge clk) begin         // по положительному фронту генератора clk
  if (reset) begin                         // если reset=1
    byte_out <= 0;                      // сброс счетчика в 0
  end 
  else  if (shift) begin             // в противном случае если shift=1
          byte_out <= {bit_in, byte_out[M-1:1]}; // сдвиг и запись значения bit_in
        end
  else;
end

endmodule

module shift_reg_par_in # (parameter M=5)  // объявляем значение параметра равным 5
(
  input clk,                                 // входы по умолчанию имеют тип wire
  input reset,
  input reg [M-1:0] bus_in,
  input set,
  input shift,
  output bit_out               // объявляем тип выхода  шина reg
);

reg [M-1:0] register;
assign bit_out = register[0];

always @(posedge clk) begin         // по положительному фронту генератора clk
  if (reset) begin                         // если reset=1
    register <= 0;                      // сброс счетчика в 0
  end 
  else if (set) begin             // в противном случае если shift=1
    register <= bus_in;
  end
  else if (shift) begin
    register <= {1'b1, register[M-1:1]};
  end
end

endmodule

`include "5_6_week/my_UART/UART_buffer.sv"
`include "5_6_week/my_UART/UART_reciever.sv"
`include "5_6_week/my_UART/UART_transmitter.sv"

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
