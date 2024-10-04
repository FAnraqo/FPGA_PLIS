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