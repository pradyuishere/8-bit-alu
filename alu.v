`define ADD 0
`define CADD 1
`define SUB 2
`define BSUB 3
`define NEG 4
`define INC 5
`define DEC 6
`define PASS 7
`define AND 8
`define OR 9
`define XOR 10
`define COMP 11
`define L_ARITH_SHIFT 12
`define R_ARITH_SHIFT 13
`define L_LOG_SHIFT 14
`define R_LOG_SHIFT 15
`define L_ROT 16
`define R_ROT 17
`define L_CROT 18
`define R_CROT 19

module alu
(
  input clk,
  input [4:0] opcode,
  input signed [7:0] operand_A,
  input signed [7:0] operand_B,
  input enable,
  input input_ready,
  input carry_in,
  input borrow_in,
  input rst,
  output reg signed [7:0] result_out,
  output reg borrow_out,
  output reg result_ready,
  output reg carry_out,
  output zero,
  output negative,
  output reg overflow
);

  
  reg signed [7:0] tmp;

  reg finished;
  reg running;

  assign zero = ~(&(result_out));
  assign negative = (result_out < 0);  

  always@( posedge clk)
    begin
      if(rst)
        begin
          carry_out <= 0;
          result_ready <= 0;
          result_out <= 0;
          overflow <= 0;
          finished <= 1;
          running <= 0;
        end
      else
        begin
          if(enable && input_ready)
            begin
              result_ready <= 0;
              overflow <= 0;
              result_out <= 0;
              carry_out <= 0;
              borrow_out <= 0;
              
              if(opcode == 0)
                begin
                  if($signed(operand_A + operand_B) < $signed(-128))
                    begin
                      borrow_out <= 1;
                      result_out <= 255 - operand_A - operand_B;
                      overflow <= 1;
                    end
                  
                  else if($signed(operand_A + operand_B) > 127)
                    begin
                      carry_out <= 1;
                      // tmp = operand_A + operand_B;
                      result_out <= operand_A + operand_B;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A + operand_B;                  

                end
              
              if(opcode == 1)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A + operand_B + carry_in );
                  if($signed(operand_A + operand_B + carry_in) < $signed(-128))
                    begin
                      $display("In <-127");
                      // $display("In alu operand_A : %d, operand_B : %d, carry_in : %d sum : %d", operand_A, operand_B, carry_in,255-( operand_A + operand_B + carry_in));
                      borrow_out <= 1;
                      result_out <= 255 - operand_A - operand_B - carry_in;
                      overflow <= 1;
                    end
                  
                  else if($signed(operand_A + operand_B + carry_in) > 127)
                    begin
                      carry_out <= 1;
                      result_out <= operand_A + operand_B + carry_in;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A + operand_B + carry_in;

                end
              
              if(opcode == 2)
                begin
                  $display("In alu operand_A : %d, sum : %b", operand_A, $signed(operand_A - operand_B));
                  if($signed(operand_A - operand_B) < $signed(-128))
                    begin
                      borrow_out <= 1;
                      result_out <= 255 - operand_A + operand_B;
                      overflow <= 1;
                    end
                  
                  else if($signed(operand_A - operand_B) > 127)
                    begin
                      carry_out <= 1;
                      result_out <= operand_A - operand_B;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A - operand_B;

                end
              
              if(opcode == 3)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A - operand_B - carry_in );
                  if($signed(operand_A - operand_B - borrow_in) <$signed(-128))
                    begin
                      borrow_out <= 1;
                      result_out <= 255 - operand_A + operand_B + borrow_in;
                      overflow <= 1;
                    end
                  
                  else if($signed(operand_A - operand_B - borrow_in) > 127)
                    begin
                      carry_out <= 1;
                      result_out <= operand_A - operand_B - borrow_in;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A - operand_B - borrow_in;

                end
              
              if(opcode == 4)
                begin
                  result_out <= -operand_A;
                end
              
              if(opcode == 5)
                begin
                  if($signed(operand_A + 1) > 127)
                    begin
                      carry_out = 1;
                      result_out <= -128;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A + 1;

                end
              
              if(opcode == 6)
                begin
                  if($signed(operand_A - 1) < $signed(-128))
                    begin
                      borrow_out <= 1;
                      result_out <= 127;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A - 1;

                end
              
              if(opcode == 7)
                begin
                  result_out <= operand_A;
                end
              
              if(opcode == 8)
                result_out <= operand_A & operand_B;
              
              if(opcode == 9)
                result_out <= operand_A | operand_B;
              
              if(opcode == 10)
                result_out <= operand_A ^ operand_B;
              
              if(opcode == 11)
                result_out <= ~operand_A;
              
              if(opcode == 12)
                begin
                  result_out[0] <= 0;
                  result_out[7:1] <= operand_A[6:0];
                end
              
              if(opcode == 13)
                begin
                  result_out[7] <= operand_A[7];
                  result_out[6:0] <= operand_A[7:1];
                end
              
              
              if(opcode == 14)
                begin
                  result_out[0] <= 0;
                  result_out[7:1] <= operand_A[6:0];
                end
              
              if(opcode == 15)
                begin
                  result_out[7] <= 0;
                  result_out[6:0] <= operand_A[7:1];
                end
              
              if(opcode == 16)
                begin
                  result_out[0] <= operand_A[7];
                  result_out[7:1] <= operand_A[6:0];
                end
              
              if(opcode == 17)
                begin
                  result_out[7] <= operand_A[0];
                  result_out[6:0] <= operand_A[7:1];
                end
              
              if(opcode == 18)
                begin
                  carry_out <= operand_A[7];
                  result_out[7:1] <= operand_A[6:0];
                  result_out[0] <= carry_in;
                end
              
              if(opcode == 19)
                begin
                  carry_out <= operand_A[0];
                  result_out[7] <= carry_in;
                  result_out[6:0] <= operand_A[7:1];
                end
              result_ready <= 1;
            end
        end
    end

endmodule
