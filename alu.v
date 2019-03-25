module alu
(
  input clk,
  input opcode,
  input operand_A,
  input operand_B,
  input enable,
  input input_ready,
  input carry_in,
  input rst,
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

  reg finished;
  reg running;
  
  reg add_instr, addc_instr, sub_instr, subb_instr, neg_instr, inc_instr, dec_instr, pass_instr, and_instr, or_instr, xor_instr;
  reg comp_instr, l_arith_shft_instr, r_arith_shft_instr, l_log_shft_instr, r_log_shft_instr, l_rot_instr, r_rot_instr, l_crot_instr, r_crot_instr;

  always@( posedge clk)
    begin
      if(rst)
        begin
          carry_out <= 0;
          zero <= 0;
          result_ready <= 0;
          y_out <= 0;
          negative <= 0;
          overflow <= 0;
          parity <= 0;
          finished <= 1;
          running <= 0;
        end
      else
        begin
          if(finished & enable & input_ready)
            begin
              
            end
        end
    end

endmodule
