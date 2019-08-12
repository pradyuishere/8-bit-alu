module alu_tb();

	reg clk, enable, input_ready, carry_in, borrow_in, rst;
	reg [4:0] opcode;
	reg signed [7:0] operand_A, operand_B;
	wire signed [7:0] result_out;
	wire zero_out, negative_out, result_ready, carry_out, overflow_out, borrow_out;

	alu alu1(
		.clk(clk),
		.opcode(opcode),
		.operand_A(operand_A),
		.operand_B(operand_B),
		.enable(enable),
		.input_ready(input_ready),
		.carry_in(carry_in),
		.borrow_in(borrow_in),
		.rst(rst),
		.result_out(result_out),
		.result_ready(result_ready),
		.carry_out(carry_out),
		.borrow_out(borrow_out),
		.zero(zero_out),
		.negative(negative_out),
		.overflow(overflow_out)
		);

	initial 
		begin
			$monitor("carry_out : %d, borrow_out : %d\nresult_out : %d\n\nopcode : %d, operand_A : %d, operand_B : %d\ncarry_in : %d, borrow_in : %d", carry_out, borrow_out, result_out, opcode, operand_A, operand_B, carry_in, borrow_in);
			clk = 0;
			rst = 1;
			opcode = 0;
			operand_A = 127;
			operand_B = 126;
			input_ready = 1;
			enable = 1;
			carry_in = 1;
			borrow_in = 1;
			#5 rst = 0;
			#200$finish;
		end

	always
		begin
			#5 clk = ~clk;
		end

	always@(posedge clk)
	begin
		opcode <= (opcode+1)%20;
		// if(opcode == 0)
		// begin
			operand_A <= $random;
			operand_B <= $random;
		// end
		input_ready <= 1;
	end

endmodule