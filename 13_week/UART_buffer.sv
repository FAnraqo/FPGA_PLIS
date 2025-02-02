module UART_buffer
    (
        input clk,
        input reset,
        input enable,
        input      [7:0] byte_in,
        output reg [7:0] byte_out,
        output reg ready
    );

    always @(posedge clk) begin
        if (reset) begin
            byte_out <= '0;
            ready <= 0;
        end else begin
            if (enable) begin

                if (byte_in == 8'b00000000) begin
                
                    byte_out <= 0;

                end

                else begin
                    
                    byte_out <= byte_in;
                    ready <= enable;

                end


            end

            if (ready) ready <= 0;

        end
    end
endmodule
