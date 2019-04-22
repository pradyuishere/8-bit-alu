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
