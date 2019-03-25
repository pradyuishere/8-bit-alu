module alu
(
  input clk,
  input opcode,
  input operand_A,
  input operand_B,
  input enable,
  input input_ready,
  input carry_in,
  output y_out,
  output result_ready,
  output carry_out,
  output zero,
  output negative,
  output overflow,
  output parity
);

reg [4:0] opcode;
reg [7:0] operand_A;
reg [7:0] operand_B;
reg [7:0] result_ready;

always@( posedge clk)
begin
  
end

endmodule
