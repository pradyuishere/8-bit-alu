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


  reg signed [7:0] temp;

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
        result_ready <= 0;
          if(enable && input_ready)
            begin

              result_ready <= 0;
              overflow <= 0;
              result_out <= 0;
              carry_out <= 0;
              borrow_out <= 0;

              if(opcode == 0)
                begin
                  temp = operand_A+operand_B;
                  if(operand_A[7]==1 && operand_B[7]==1 && temp[7]==0)
                    begin
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end

                  else if(operand_A[7]==0 && operand_B[7]==0 && temp[7]==1)
                    begin
                      carry_out <= 1;
                      // tmp = operand_A + operand_B;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;

                end

              if(opcode == 1)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A + operand_B + carry_in );
                  temp = operand_A+operand_B+carry_in;
                  if(operand_A[7]==1 && operand_B[7]==1 && temp[7]==0)
                    begin
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end

                  else if(operand_A[7]==0 && operand_B[7]==0 && temp[7]==1)
                    begin
                      carry_out <= 1;
                      // tmp = operand_A + operand_B;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;
                end

              if(opcode == 2)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, $signed(operand_A - operand_B));
                  temp = operand_A - operand_B;
                  if(operand_A[7]==1 && operand_B[7]==0 && temp[7]==0)
                    begin
                      // $display("In <-127");
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  // operand_A[7]==0 && operand_B[7]==1 && temp[7]==0
                  else if(operand_A[7]==0 && operand_B[7]==1 && temp[7]==1)
                    begin
                      // $display("In >127");
                      carry_out <= 1;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;

                end

              if(opcode == 3)
                begin
                  // $display("In alu operand_A : %d, sum : %d", operand_A, operand_A - operand_B - carry_in );
                  temp = operand_A - operand_B - borrow_in;
                  if(operand_A[7]==1 && operand_B[7]==0 && temp[7]==0)
                    begin
                      // $display("In <-127");
                      borrow_out <= 1;
                      result_out <= temp-128;
                      overflow <= 1;
                    end
                  // operand_A[7]==0 && operand_B[7]==1 && temp[7]==0
                  else if(operand_A[7]==0 && operand_B[7]==1 && temp[7]==1)
                    begin
                      // $display("In >127");
                      carry_out <= 1;
                      result_out <= temp+128;
                      overflow <= 1;
                    end
                  else
                    result_out <= temp;

                end

              if(opcode == 4)
                begin
                  if(operand_A==-128)
                    begin
                      carry_out <= 1;
                      result_out <= 0;
                      overflow <= 1;
                    end
                  else
                    result_out <= -operand_A;
                end

              if(opcode == 5)
                begin
                  if(operand_A==127)
                    begin
                      carry_out <= 1;
                      result_out <= 0;
                      overflow <= 1;
                    end
                  else
                    result_out <= operand_A + 1;

                end

              if(opcode == 6)
                begin
                  if(operand_A == -128)
                    begin
                      borrow_out <= 1;
                      result_out <= -1;
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
                  // $display("operand_A : %b", operand_A);
                  result_out[0] <= operand_A[7];
                  result_out[7:1] <= operand_A[6:0];
                  // $display("operand_A[7] : %b", operand_A[7]);
                  // $display("operand_A[6:0] : %b", operand_A[6:0]);
                  // $display("result_out : %b", result_out);
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
              // $display("enable : %d, input_ready : %d in alu", enable, input_ready);
            end
        end
    end

endmodule

module wrapper_alu(
  input clk,
  input rst,
  input [7:0] data_in,
  output reg [7:0] data_out,
  output reg next_in,
  output reg output_done
  );
    reg next_inputs, clk_alu, clk_pick;
    reg [26:0] alu_delay, pick_delay;
    reg [4:0] opcode;
    reg [7:0] operand_A, operand_B;
    wire [7:0] result_out;
    wire carry_out, borrow_out, zero, negative, overflow, result_ready;
    reg enable, input_ready, carry_in, borrow_in;

    integer state_inputs, state_outputs;

    alu a1(
      .clk(clk_alu),
      .opcode(opcode),
      .operand_A(operand_A),
      .operand_B(operand_B),
      .enable(enable),
      .input_ready(input_ready),
      .carry_in(carry_in),
      .borrow_in(borrow_in),
      .rst(rst),
      //outputs begin
      .result_out(result_out),
      .borrow_out(borrow_out),
      .result_ready(result_ready),
      .carry_out(carry_out),
      .zero(zero),
      .negative(negative),
      .overflow(overflow)
      );

  initial begin
    clk_alu = 0;
    clk_pick = 0;
    pick_delay = 27'd0 - 1;
    state_inputs = 0;
    state_outputs = 0;
    alu_delay = 0;
    enable = 1;
  end

  always@(posedge clk)
  begin
    alu_delay = alu_delay+1;
    if(alu_delay == 27'd5000000)
    begin
      alu_delay = 0;
      clk_alu = ~clk_alu;
    end
  end

  always@(posedge clk)
  begin
    pick_delay = pick_delay+1;
    if(pick_delay == 27'd50000000)
    begin
      pick_delay = 0;
      clk_pick = ~clk_pick;
    end
  end

  always@(posedge clk_pick)
  begin
    if(input_ready == 1)
      input_ready = 0;

    if(state_inputs == 0)
    begin
      opcode = data_in[4:0];
      data_out = result_out;
      output_done = 0;
      next_in = 0;
    end
    else if(state_inputs == 1)
    begin
      operand_A = data_in;
      data_out = borrow_out;
    end
    else if(state_inputs == 2)
    begin
      operand_B = data_in;
      data_out = carry_out;
    end
    else if(state_inputs == 3)
    begin
      carry_in = data_in[0];
      data_out = zero;
    end
    else if(state_inputs == 4)
    begin
      borrow_in = data_in[0];
      data_out = negative;
    end
    else if(state_inputs == 5)
    begin
      data_out = overflow;
      output_done = 1;
    end
    else if(state_inputs == 6)
    begin
      next_in = 1;
      input_ready = 1;
    end

    state_inputs = state_inputs + 1;
    if(state_inputs==7)
    begin
      state_inputs = 0;
    end

  end

  endmodule
