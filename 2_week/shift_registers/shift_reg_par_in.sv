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